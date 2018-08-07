# frozen_string_literal: true

module Gitlab
  # Wrapper class of file response.
  class FileResponse
    HEADER_CONTENT_DISPOSITION = 'Content-Disposition'

    attr_reader :filename

    def initialize(file)
      @file = file
    end

    # @return [bool] Always false
    def empty?
      false
    end

    # @return [Hash] A hash consisting of filename and io object
    def to_hash
      { filename: @filename, data: @file }
    end
    alias to_h to_hash

    # @return [String] Formatted string with the class name, object id and filename.
    def inspect
      "#<#{self.class}:#{object_id} {filename: #{filename.inspect}}>"
    end

    def method_missing(name, *args, &block)
      if @file.respond_to?(name)
        @file.send(name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      super || @file.respond_to?(method_name, include_private)
    end

    # Parse filename from the 'Content Disposition' header.
    def parse_headers!(headers)
      @filename = headers[HEADER_CONTENT_DISPOSITION].split('filename=')[1]
      @filename = @filename[1...-1] if @filename[0] == '"' # Unquote filenames
    end
  end
end
