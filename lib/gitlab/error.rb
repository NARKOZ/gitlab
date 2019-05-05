# frozen_string_literal: true

module Gitlab
  module Error
    # Custom error class for rescuing from all Gitlab errors.
    class Error < StandardError; end

    # Raised when API endpoint credentials not configured.
    class MissingCredentials < Error; end

    # Raised when impossible to parse response body.
    class Parsing < Error; end

    # Custom error class for rescuing from HTTP response errors.
    class ResponseError < Error
      POSSIBLE_MESSAGE_KEYS = %i[message error_description error].freeze

      def initialize(response)
        @response = response
        super(build_error_message)
      end

      # Status code returned in the HTTP response.
      #
      # @return [Integer]
      def response_status
        @response.code
      end

      # Body content returned in the HTTP response
      #
      # @return [String]
      def response_message
        @response.parsed_response.message
      end

      private

      # Human friendly message.
      #
      # @return [String]
      def build_error_message
        parsed_response = classified_response
        message = check_error_keys(parsed_response)
        "Server responded with code #{@response.code}, message: " \
        "#{handle_message(message)}. " \
        "Request URI: #{@response.request.base_uri}#{@response.request.path}"
      end

      # Error keys vary across the API, find the first key that the parsed_response
      # object responds to and return that, otherwise return the original.
      def check_error_keys(resp)
        key = POSSIBLE_MESSAGE_KEYS.find { |k| resp.respond_to?(k) }
        key ? resp.send(key) : resp
      end

      # Parse the body based on the classification of the body content type
      #
      # @return parsed response
      def classified_response
        if @response.respond_to?('headers')
          @response.headers['content-type'] == 'text/plain' ? { message: @response.to_s } : @response.parsed_response
        else
          @response.parsed_response
        end
      end

      # Handle error response message in case of nested hashes
      def handle_message(message)
        case message
        when Gitlab::ObjectifiedHash
          message.to_h.sort.map do |key, val|
            "'#{key}' #{(val.is_a?(Hash) ? val.sort.map { |k, v| "(#{k}: #{v.join(' ')})" } : [val].flatten).join(' ')}"
          end.join(', ')
        when Array
          message.join(' ')
        else
          message
        end
      end
    end

    # Raised when API endpoint returns the HTTP status code 400.
    class BadRequest < ResponseError; end

    # Raised when API endpoint returns the HTTP status code 401.
    class Unauthorized < ResponseError; end

    # Raised when API endpoint returns the HTTP status code 403.
    class Forbidden < ResponseError; end

    # Raised when API endpoint returns the HTTP status code 404.
    class NotFound < ResponseError; end

    # Raised when API endpoint returns the HTTP status code 405.
    class MethodNotAllowed < ResponseError; end

    # Raised when API endpoint returns the HTTP status code 409.
    class Conflict < ResponseError; end

    # Raised when API endpoint returns the HTTP status code 422.
    class Unprocessable < ResponseError; end

    # Raised when API endpoint returns the HTTP status code 429.
    class TooManyRequests < ResponseError; end

    # Raised when API endpoint returns the HTTP status code 500.
    class InternalServerError < ResponseError; end

    # Raised when API endpoint returns the HTTP status code 502.
    class BadGateway < ResponseError; end

    # Raised when API endpoint returns the HTTP status code 503.
    class ServiceUnavailable < ResponseError; end

    # HTTP status codes mapped to error classes.
    STATUS_MAPPINGS = {
      400 => BadRequest,
      401 => Unauthorized,
      403 => Forbidden,
      404 => NotFound,
      405 => MethodNotAllowed,
      409 => Conflict,
      422 => Unprocessable,
      429 => TooManyRequests,
      500 => InternalServerError,
      502 => BadGateway,
      503 => ServiceUnavailable
    }.freeze
  end
end
