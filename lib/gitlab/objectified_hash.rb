module Gitlab
  # Converts hashes to the objects.
  class ObjectifiedHash
    # Creates a new ObjectifiedHash.
    def initialize(hash)
      @data = hash.inject({}) do |data, (key,value)|
        value = ObjectifiedHash.new(value) if value.is_a? Hash
        data[key.to_s] = value
        data
      end
    end

    # Patches Object#id in Ruby 1.8
    def id
      @data['id']
    end

    # Delegate to ObjectifiedHash
    def method_missing(key)
      @data.key?(key.to_s) ? @data[key.to_s] : nil
    end
  end
end
