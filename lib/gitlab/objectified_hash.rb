# frozen_string_literal: true

module Gitlab
  # Converts hashes to the objects.
  class ObjectifiedHash
    # Creates a new ObjectifiedHash object.
    def initialize(hash)
      @hash = hash
      @data = hash.each_with_object({}) do |(key, value), data|
        value = self.class.new(value) if value.is_a? Hash
        data[key.to_s] = value
      end
    end

    # @return [Hash] The original hash.
    def to_hash
      @hash
    end
    alias to_h to_hash

    # @return [String] Formatted string with the class name, object id and original hash.
    def inspect
      "#<#{self.class}:#{object_id} {hash: #{@hash.inspect}}"
    end

    private

    # Respond to messages for which `@data` has a key
    def method_missing(name, *arguments, &block)
      if @data.key?(name.to_s)
        @data[name.to_s]
      elsif @hash.respond_to?(name)
        @hash.send(name, *arguments, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @hash.keys.map(&:to_sym).include?(method_name.to_sym) || super
    end
  end
end
