# frozen_string_literal: true

require 'httparty'
require 'json'

module Gitlab
  # @private
  class Request
    include HTTParty
    format :json
    headers 'Accept' => 'application/json', 'Content-Type' => 'application/x-www-form-urlencoded'
    parser(proc { |body, _| parse(body) })

    attr_accessor :private_token, :endpoint

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

    %w[get post put delete].each do |method|
      define_method method do |path, options = {}|
        params = options.dup

        httparty_config(params)

        unless params[:unauthenticated]
          params[:headers] ||= {}
          params[:headers].merge!(authorization_header)
        end

        validate self.class.send(method, endpoint + path, params)
      end
    end

    # Checks the response code for common errors.
    # Returns parsed response for successful requests.
    def validate(response)
      error_klass = Error::STATUS_MAPPINGS[response.code]
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

      if private_token.size < 21
        { 'PRIVATE-TOKEN' => private_token }
      else
        { 'Authorization' => "Bearer #{private_token}" }
      end
    end

    # Set HTTParty configuration
    # @see https://github.com/jnunemaker/httparty
    def httparty_config(options)
      options.merge!(httparty) if httparty
    end
  end
end
