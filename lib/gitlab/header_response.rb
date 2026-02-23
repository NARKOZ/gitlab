# frozen_string_literal: true

module Gitlab
  class HeaderResponse
    GITLAB_HEADER = 'x-gitlab-'

    def initialize
      @headers = {}
    end

    def empty?
      headers.empty?
    end

    def to_hash
      headers
    end
    alias to_h to_hash

    def method_missing(method, *args, &)
      if headers.key?(method)
        headers[method]
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      headers.key?(method) || super
    end

    def inspect
      "#<#{self.class}:#{object_id} #{headers}>"
    end

    def parse_headers!(headers)
      @headers = headers.select { |header, _value| header.include?(GITLAB_HEADER) }
                        .map { |header, value| { header_key(header) => value[0] } }
                        .reduce(&:merge)
    end

    private

    attr_reader :headers

    def header_key(header)
      header.gsub(GITLAB_HEADER, '').tr('-', '_').to_sym
    end
  end
end
