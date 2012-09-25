require 'httparty'

module Gitlab
  # @private
  class Request
    include HTTParty
    format  :json
    headers 'Accept' => 'application/json'
    parser  Proc.new {|body| parse(body)}

    # Converts the response body to an ObjectifiedHash.
    def self.parse(body)
      body = decode(body)

      if body.is_a? Hash
        ObjectifiedHash.new body
      elsif body.is_a? Array
        body.collect! {|e| ObjectifiedHash.new(e)}
      else
        raise Error::Parsing.new "Couldn't parse a response body"
      end
    end

    # Decodes a JSON response into Ruby object.
    def self.decode(response)
      begin
        if MultiJson.respond_to?(:adapter)
          MultiJson.load response
        else
          MultiJson.decode response
        end
      rescue MultiJson::DecodeError
        raise Error::Parsing.new "The response is not a valid JSON"
      end
    end

    def get(path, options={})
      validate self.class.get(path, options)
    end

    def post(path, options={})
      validate self.class.post(path, options)
    end

    def put(path, options={})
      validate self.class.put(path, options)
    end

    def delete(path)
      validate self.class.delete(path)
    end

    # Checks the response code for common errors.
    # Returns parsed response for successful requests.
    def validate(response)
      message = "Server responsed with code #{response.code}"
      case response.code
      when 400; raise Error::BadRequest.new message
      when 401; raise Error::Unauthorized.new message
      when 403; raise Error::Forbidden.new message
      when 404; raise Error::NotFound.new message
      when 500; raise Error::InternalServerError.new message
      when 502; raise Error::BadGateway.new message
      when 503; raise Error::ServiceUnavailable.new message
      end

      response.parsed_response
    end

    # Sets a base_uri and private_token parameter for requests.
    # @raise [Error::MissingCredentials] if endpoint or private_token not set.
    def set_request_defaults(endpoint, private_token)
      raise Error::MissingCredentials.new("Please set an endpoint to API") unless endpoint
      raise Error::MissingCredentials.new("Please set a private_token for user") unless private_token

      self.class.base_uri endpoint
      self.class.default_params :private_token => private_token
    end
  end
end
