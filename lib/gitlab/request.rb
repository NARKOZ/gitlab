require 'httparty'
require 'json'

module Gitlab
  # @private
  class Request
    include HTTParty
    format :json
    headers 'Accept' => 'application/json'
    parser Proc.new { |body, _| parse(body) }

    attr_accessor :private_token

    # Converts the response body to an ObjectifiedHash.
    def self.parse(body)
      body = decode(body)

      if body.is_a? Hash
        ObjectifiedHash.new body
      elsif body.is_a? Array
        body.collect! { |e| ObjectifiedHash.new(e) }
      else
        raise Error::Parsing.new "Couldn't parse a response body"
      end
    end

    # Decodes a JSON response into Ruby object.
    def self.decode(response)
      begin
        JSON.load response
      rescue JSON::ParserError
        raise Error::Parsing.new "The response is not a valid JSON"
      end
    end

    def get(path, options={})
      set_private_token_header(options)
      validate self.class.get(path, options)
    end

    def post(path, options={})
      set_private_token_header(options, path)
      validate self.class.post(path, options)
    end

    def put(path, options={})
      set_private_token_header(options)
      validate self.class.put(path, options)
    end

    def delete(path, options={})
      set_private_token_header(options)
      validate self.class.delete(path, options)
    end

    # Checks the response code for common errors.
    # Returns parsed response for successful requests.
    def validate(response)
      case response.code
        when 400; raise Error::BadRequest.new error_message(response)
        when 401; raise Error::Unauthorized.new error_message(response)
        when 403; raise Error::Forbidden.new error_message(response)
        when 404; raise Error::NotFound.new error_message(response)
        when 405; raise Error::MethodNotAllowed.new error_message(response)
        when 409; raise Error::Conflict.new error_message(response)
        when 500; raise Error::InternalServerError.new error_message(response)
        when 502; raise Error::BadGateway.new error_message(response)
        when 503; raise Error::ServiceUnavailable.new error_message(response)
      end

      response.parsed_response
    end

    # Sets a base_uri and default_params for requests.
    # @raise [Error::MissingCredentials] if endpoint not set.
    def set_request_defaults(endpoint, private_token, sudo=nil)
      raise Error::MissingCredentials.new("Please set an endpoint to API") unless endpoint
      @private_token = private_token

      self.class.base_uri endpoint
      self.class.default_params :sudo => sudo
      self.class.default_params.delete(:sudo) if sudo.nil?
    end

    private

    # Sets a PRIVATE-TOKEN header for requests.
    # @raise [Error::MissingCredentials] if private_token not set.
    def set_private_token_header(options, path=nil)
      unless path == '/session'
        raise Error::MissingCredentials.new("Please set a private_token for user") unless @private_token
        options[:headers] = {'PRIVATE-TOKEN' => @private_token}
      end
    end

    def error_message(response)
      "Server responded with code #{response.code}, message: #{response.parsed_response["message"]}. " \
      "Request URI: #{response.request.base_uri}#{response.request.path}"
    end
  end
end
