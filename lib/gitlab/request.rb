require 'httparty'

module Gitlab
  # @private
  class Request
    include HTTParty
    format :json
    headers 'Accept' => 'application/json'
    parser Proc.new { |body, _| parse(body) }

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
    # If email and password provided, get GitLab session and extract private_token from it.
    # @raise [Error::MissingCredentials] if endpoint is not set.
    # @raise [Error::MissingCredentials] if
    #        private_token OR (email AND password) are not set.
    def set_request_defaults(endpoint, private_token, email, password, sudo=nil)
      raise Error::MissingCredentials.new("Please set an endpoint to API") unless endpoint
      self.class.base_uri endpoint
      
      unless private_token
        unless email and password
          raise Error::MissingCredentials.new("Please set a private_token or email and password for user")    
        end
        response = post("/session", :body => { email: email, password: password })
        private_token = response.private_token
        @password = nil #security?
      end
      self.class.default_params :private_token => private_token, :sudo => sudo
      self.class.default_params.delete(:sudo) if sudo.nil?
    end

    private

    def error_message(response)
      "Server responded with code #{response.code}, message: #{response.parsed_response.message}. " \
      "Request URI: #{response.request.base_uri}#{response.request.path}"
    end
  end
end
