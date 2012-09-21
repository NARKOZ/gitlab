require 'httparty'

module Gitlab
  # @private
  class Request
    include HTTParty
    format :json
    headers 'Accept' => 'application/json'
    parser  Proc.new {|body| make_objectified_hash(body)}

    # Parses the response body.
    def self.make_objectified_hash(body)
      begin
        response = MultiJson.respond_to?(:adapter) ? MultiJson.load(body) : MultiJson.decode(body)
      rescue MultiJson::DecodeError
        raise Error::Parsing.new "Couldn't parse a response body"
      end

      if response.is_a? Hash
        ObjectifiedHash.new response
      elsif response.is_a? Array
        response.collect! {|e| ObjectifiedHash.new(e)}
      else
        raise Error::Parsing.new "Couldn't parse a response body"
      end
    end

    def get(path, options={})
      validate_response self.class.get(path, options)
    end

    def post(path, options={})
      validate_response self.class.post(path, options)
    end

    def put(path, options={})
      validate_response self.class.put(path, options)
    end

    def delete(path)
      validate_response self.class.delete(path)
    end

    def set_request_defaults(endpoint, private_token)
      raise Error::MissingCredentials.new("Please set an endpoint") unless endpoint
      raise Error::MissingCredentials.new("Please set a private_token") unless private_token

      self.class.base_uri endpoint
      self.class.default_params :private_token => private_token
    end

    def validate_response(response)
      case response.code
      when 400
        raise Error::BadRequest.new "Server responsed with code #{response.code}"
      when 401
        raise Error::Unauthorized.new "Server responsed with code #{response.code}"
      when 403
        raise Error::Forbidden.new "Server responsed with code #{response.code}"
      when 404
        raise Error::NotFound.new "Server responsed with code #{response.code}"
      when 500
        raise Error::InternalServerError.new "Server responsed with code #{response.code}"
      when 502
        raise Error::BadGateway.new "Server responsed with code #{response.code}"
      when 503
        raise Error::ServiceUnavailable.new "Server responsed with code #{response.code}"
      end

      response.parsed_response
    end
  end
end
