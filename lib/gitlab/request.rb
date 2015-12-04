require 'httparty'
require 'json'

module Gitlab
  # @private
  class Request
    include HTTParty
    format :json
    headers 'Accept' => 'application/json'
    parser proc { |body, _| parse(body) }

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
      elsif body.nil?
        false
      else
        raise Error::Parsing.new "Couldn't parse a response body"
      end
    end

    # Decodes a JSON response into Ruby object.
    def self.decode(response)
      JSON.load response
    rescue JSON::ParserError
      raise Error::Parsing.new "The response is not a valid JSON"
    end

    def get(path, options={})
      set_httparty_config(options)
      set_authorization_header(options)
      validate self.class.get(@endpoint + path, options)
    end

    def post(path, options={})
      set_httparty_config(options)
      set_authorization_header(options, path)
      validate self.class.post(@endpoint + path, options)
    end

    def put(path, options={})
      set_httparty_config(options)
      set_authorization_header(options)
      validate self.class.put(@endpoint + path, options)
    end

    def delete(path, options={})
      set_httparty_config(options)
      set_authorization_header(options)
      validate self.class.delete(@endpoint + path, options)
    end

    # Checks the response code for common errors.
    # Returns parsed response for successful requests.
    def validate(response)
      case response.code
      when 400 then fail Error::BadRequest.new error_message(response)
      when 401 then fail Error::Unauthorized.new error_message(response)
      when 403 then fail Error::Forbidden.new error_message(response)
      when 404 then fail Error::NotFound.new error_message(response)
      when 405 then fail Error::MethodNotAllowed.new error_message(response)
      when 409 then fail Error::Conflict.new error_message(response)
      when 422 then fail Error::Unprocessable.new error_message(response)
      when 500 then fail Error::InternalServerError.new error_message(response)
      when 502 then fail Error::BadGateway.new error_message(response)
      when 503 then fail Error::ServiceUnavailable.new error_message(response)
      end

      parsed = response.parsed_response
      parsed.client = self if parsed.respond_to?(:client=)
      parsed.parse_headers!(response.headers) if parsed.respond_to?(:parse_headers!)
      parsed
    end

    # Sets a base_uri and default_params for requests.
    # @raise [Error::MissingCredentials] if endpoint not set.
    def set_request_defaults(sudo=nil)
      self.class.default_params sudo: sudo
      raise Error::MissingCredentials.new("Please set an endpoint to API") unless @endpoint
      self.class.default_params.delete(:sudo) if sudo.nil?
    end

    private

    # Sets a PRIVATE-TOKEN or Authorization header for requests.
    # @raise [Error::MissingCredentials] if private_token and auth_token are not set.
    def set_authorization_header(options, path=nil)
      unless path == '/session'
        raise Error::MissingCredentials.new("Please provide a private_token or auth_token for user") unless @private_token
        if @private_token.length <= 20
          options[:headers] = { 'PRIVATE-TOKEN' => @private_token }
        else
          options[:headers] = { 'Authorization' => "Bearer #{@private_token}" }
        end
      end
    end

    # Set HTTParty configuration
    # @see https://github.com/jnunemaker/httparty
    def set_httparty_config(options)
      options.merge!(httparty) if httparty
    end

    def error_message(response)
      parsed_response = response.parsed_response
      message = parsed_response.message || parsed_response.error

      "Server responded with code #{response.code}, message: " \
      "#{handle_error(message)}. " \
      "Request URI: #{response.request.base_uri}#{response.request.path}"
    end

    # Handle error response message in case of nested hashes
    def handle_error(message)
      case message
      when Gitlab::ObjectifiedHash
        message.to_h.sort.map do |key, val|
          "'#{key}' #{(val.is_a?(Hash) ? val.sort.map { |k, v| "(#{k}: #{v.join(' ')})" } : val).join(' ')}"
        end.join(', ')
      when Array
        message.join(' ')
      else
        message
      end
    end
  end
end
