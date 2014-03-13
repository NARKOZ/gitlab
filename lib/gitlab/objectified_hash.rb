require 'hashie/extensions/coercion'
require 'hashie/extensions/indifferent_access'
require 'hashie/extensions/method_access'
require 'base64'

module Gitlab
  # Converts hashes to the objects.
  class ObjectifiedHash < ::Hash
    include ::Hashie::Extensions::Coercion
    include ::Hashie::Extensions::IndifferentAccess
    include ::Hashie::Extensions::MethodReader
    include ::Hashie::Extensions::MethodQuery

    coerce_value ::Hash, ObjectifiedHash

    def initialize(hash)
      hash.each_pair do |key, value|
        self[key] = _convert_value value
      end

      if key?(:encoding) && key?(:content)
        case self[:encoding]
        when 'base64'
          self[:decoded_content] = Base64.decode64(self[:content])
        else
          warn "Unable to decode content with encoding #{self[:encoding]}"
        end
      end
    end

    def key(value=:unset)
      if self[:key]
        raise ArgumentError, 'wrong number of arguments (1 for 0)' if value != :unset
        self[:key]
      else
        super
      end
    end

    def _convert_value(value)
      case value
      when self.class
        value.dup
      when ::Hash
        self.class.new(value.dup)
      when ::Enumerable
        value.collect{ |e| _convert_value(e) }
      else
        value
      end
    end
  end
end
