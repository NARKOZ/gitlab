# frozen_string_literal: true

module Gitlab
  # Parses link header.
  #
  # @private
  class PageLinks
    HEADER_LINK = 'Link'
    DELIM_LINKS = ','
    LINK_REGEX = /<([^>]+)>; rel="([^"]+)"/.freeze
    METAS = %w[last next first prev].freeze

    attr_accessor(*METAS)

    def initialize(headers)
      link_header = headers[HEADER_LINK]

      extract_links(link_header) if link_header && link_header =~ /(next|first|last|prev)/
    end

    private

    def extract_links(header)
      header.split(DELIM_LINKS).each do |link|
        LINK_REGEX.match(link.strip) do |match|
          url = match[1]
          meta = match[2]
          next if !url || !meta || METAS.index(meta).nil?

          send("#{meta}=", url)
        end
      end
    end
  end
end
