module Gitlab
  # Converts hashes to the objects.
  class ObjectifiedHash
    # Creates a new ObjectifiedHash object.
    def initialize(hash)
      @hash = hash
      @data = hash.inject({}) do |data, (key,value)|
        value = ObjectifiedHash.new(value) if value.is_a? Hash
        data[key.to_s] = value
        data
      end
    end

    def to_hash
      @hash
    end
    alias_method :to_h, :to_hash

    # Delegate to ObjectifiedHash.
    def method_missing(key)
      @data.key?(key.to_s) ? @data[key.to_s] : nil
    end

    def respond_to?(method_name, include_private = false)
      @hash.keys.map(&:to_sym).include?(method_name.to_sym) || super
    end
  end
end
