# frozen_string_literal: true

module Gitlab
  # Wrapper class of paginated response.
  class PaginatedResponse
    attr_accessor :client

    def initialize(array)
      @array = array
    end

    def ==(other)
      @array == other
    end

    def inspect
      @array.inspect
    end

    def method_missing(name, *args, &block)
      if @array.respond_to?(name)
        @array.send(name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      super || @array.respond_to?(method_name, include_private)
    end

    def parse_headers!(headers)
      @links = PageLinks.new headers
    end

    def each_page
      current = self
      yield current
      while current.has_next_page?
        current = current.next_page
        yield current
      end
    end

    def auto_paginate
      response = block_given? ? nil : []
      each_page do |page|
        if block_given?
          page.each do |item|
            yield item
          end
        else
          response += page
        end
      end
      response
    end

    def paginate_with_limit(limit)
      response = block_given? ? nil : []
      count = 0
      each_page do |page|
        if block_given?
          page.each do |item|
            yield item
            count += 1
            break if count >= limit
          end
        else
          response += page[0, limit - count]
          count = response.length
        end
        break if count >= limit
      end
      response
    end

    def last_page?
      !(@links.nil? || @links.last.nil?)
    end
    alias has_last_page? last_page?

    def last_page
      return nil if @client.nil? || !has_last_page?

      @client.get(client_relative_path(@links.last))
    end

    def first_page?
      !(@links.nil? || @links.first.nil?)
    end
    alias has_first_page? first_page?

    def first_page
      return nil if @client.nil? || !has_first_page?

      @client.get(client_relative_path(@links.first))
    end

    def next_page?
      !(@links.nil? || @links.next.nil?)
    end
    alias has_next_page? next_page?

    def next_page
      return nil if @client.nil? || !has_next_page?

      @client.get(client_relative_path(@links.next))
    end

    def prev_page?
      !(@links.nil? || @links.prev.nil?)
    end
    alias has_prev_page? prev_page?

    def prev_page
      return nil if @client.nil? || !has_prev_page?

      @client.get(client_relative_path(@links.prev))
    end

    def client_relative_path(link)
      client_endpoint_path = URI.parse(@client.endpoint).request_uri # api/v4
      URI.parse(link).request_uri.sub(client_endpoint_path, '')
    end
  end
end
