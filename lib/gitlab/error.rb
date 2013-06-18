module Gitlab
  module Error
    # Custom error class for rescuing from all Gitlab errors.
    class Error < StandardError; end

    # Raised when API endpoint credentials not configured.
    class MissingCredentials < Error; end

    # Raised when impossible to parse response body.
    class Parsing < Error; end

    # Raised when API endpoint returns the HTTP status code 400.
    class BadRequest < Error; end

    # Raised when API endpoint returns the HTTP status code 401.
    class Unauthorized < Error; end

    # Raised when API endpoint returns the HTTP status code 403.
    class Forbidden < Error; end

    # Raised when API endpoint returns the HTTP status code 404.
    class NotFound < Error; end

    # Raised when API endpoint returns the HTTP status code 409.
    class Conflict < Error; end

    # Raised when API endpoint returns the HTTP status code 500.
    class InternalServerError < Error; end

    # Raised when API endpoint returns the HTTP status code 502.
    class BadGateway < Error; end

    # Raised when API endpoint returns the HTTP status code 503.
    class ServiceUnavailable < Error; end
  end
end
