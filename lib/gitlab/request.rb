# frozen_string_literal: true

require 'httparty'
require 'json'

module Gitlab
  # @private
  class Request
    include HTTParty
    format :json
    maintain_method_across_redirects true
    headers 'Accept' => 'application/json', 'Content-Type' => 'application/x-www-form-urlencoded'
    parser(proc { |body, _| parse(body) })

    attr_accessor :private_token, :endpoint, :pat_prefix, :body_as_json, :before_hooks, :around_hooks, :after_hooks

    # Converts the response body to an ObjectifiedHash.
    def self.parse(body)
      body = decode(body)

      if body.is_a? Hash
        ObjectifiedHash.new body
      elsif body.is_a? Array
        PaginatedResponse.new(body.collect! { |e| ObjectifiedHash.new(e) })
      elsif body
        true
      elsif !body
        false
      else
        raise Error::Parsing, "Couldn't parse a response body"
      end
    end

    # Decodes a JSON response into Ruby object.
    def self.decode(response)
      response ? JSON.load(response) : {}
    rescue JSON::ParserError
      raise Error::Parsing, 'The response is not a valid JSON'
    end

    %w[get post put patch delete].each do |method|
      define_method method do |path, options = {}|
        params = options.dup

        httparty_config(params)

        unless params[:unauthenticated]
          params[:headers] ||= {}
          params[:headers].merge!(authorization_header)
        end

        jsonify_body_content(params) if body_as_json

        execute_before_hooks(method, path, params)

        execute_with_around_hooks(method, path, params) do
          execute_api_call(method, path, params)
        end
      end
    end

    def execute_api_call(method, path, params)
      response = self.class.send(method, endpoint + path, params)
      validate response
    ensure
      execute_after_hooks(response, method, path, params)
    end

    def execute_with_around_hooks(method, path, params, &api_block)
      return yield if around_hooks.nil? || around_hooks.empty?

      full_collection = around_hooks.inject(api_block) do |collection, around_hook|
        proc { around_hook.call(method, path, params, collection) }
      end

      full_collection.call
    end

    def execute_before_hooks(method, path, params)
      before_hooks&.each do |hook|
        hook.call(method:, path:, params:)
      end
    end

    def execute_after_hooks(response, method, path, params)
      after_hooks&.each do |hook|
        hook.call(response: response.dup, method:, path:, params:)
      end
    end

    # Checks the response code for common errors.
    # Returns parsed response for successful requests.
    def validate(response)
      error_klass = Error.klass(response)
      raise error_klass, response if error_klass

      parsed = response.parsed_response
      parsed.client = self if parsed.respond_to?(:client=)
      parsed.parse_headers!(response.headers) if parsed.respond_to?(:parse_headers!)
      parsed
    end

    # Sets a base_uri and default_params for requests.
    # @raise [Error::MissingCredentials] if endpoint not set.
    def request_defaults(sudo = nil)
      raise Error::MissingCredentials, 'Please set an endpoint to API' unless endpoint

      self.class.default_params sudo: sudo
      self.class.default_params.delete(:sudo) if sudo.nil?
    end

    private

    # Returns an Authorization header hash
    #
    # @raise [Error::MissingCredentials] if private_token and auth_token are not set.
    def authorization_header
      raise Error::MissingCredentials, 'Please provide a private_token or auth_token for user' unless private_token

      # The Personal Access Token prefix can be at most 20 characters, and the
      # generated part is of length 20 characters. Personal Access Tokens, thus
      # can have a maximum size of 40 characters. GitLab uses
      # `Doorkeeper::OAuth::Helpers::UniqueToken.generate` for generating
      # OAuth2 tokens, and specified `hex` as token generator method. Thus, the
      # OAuth2 tokens are of length more than 64. If the token length is below
      # that, it is probably a Personal Access Token or CI_JOB_TOKEN.
      if private_token.size >= 64
        { 'Authorization' => "Bearer #{private_token}" }
      elsif private_token.start_with?(pat_prefix.to_s)
        { 'PRIVATE-TOKEN' => private_token }
      else
        { 'JOB-TOKEN' => private_token }
      end
    end

    # Set HTTParty configuration
    # @see https://github.com/jnunemaker/httparty
    def httparty_config(options)
      options.merge!(httparty) if httparty
    end

    # Handle 'body_as_json' configuration option
    # Modifies passed params in place.
    def jsonify_body_content(params)
      # Only modify the content type if there is a body to process AND multipath
      # was not explicitly requested. There are no uses of multipart in this code
      # today, but file upload methods require it and someone might be manually
      # crafting a post call with it:
      return unless params[:body] && params[:multipart] != true

      # If the caller explicitly requested a Content-Type during the call, assume
      # they know best and have formatted the body as required:
      return if params[:headers]&.key?('Content-Type')

      # If we make it here, then we assume it is safe to JSON encode the body:
      params[:headers] ||= {}
      params[:headers]['Content-Type'] = 'application/json'
      params[:body] = params[:body].to_json
    end
  end
end
