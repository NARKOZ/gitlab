# frozen_string_literal: true

module Gitlab
  module Headers
    # Parses total header.
    #
    # @private
    class Total
      HEADER_TOTAL = 'x-total'
      TOTAL_REGEX = /^\d+$/.freeze

      attr_accessor :total

      def initialize(headers)
        header_total = headers[HEADER_TOTAL]

        extract_total(header_total) if header_total
      end

      private

      def extract_total(header_total)
        TOTAL_REGEX.match(header_total.strip) do |match|
          @total = match[0]
        end
      end
    end
  end
end
