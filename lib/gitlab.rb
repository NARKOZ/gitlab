# frozen_string_literal: true

require 'gitlab/version'
require 'gitlab/objectified_hash'
require 'gitlab/configuration'
require 'gitlab/error'
require 'gitlab/page_links'
require 'gitlab/paginated_response'
require 'gitlab/file_response'
require 'gitlab/request'
require 'gitlab/api'
require 'gitlab/client'

module Gitlab
  extend Configuration

  # Alias for Gitlab::Client.new
  #
  # @return [Gitlab::Client]
  def self.client(options = {})
    Gitlab::Client.new(options)
  end

  if Gem::Version.new(RUBY_VERSION).release >= Gem::Version.new('3.0.0')
    def self.method_missing(method, *args, **keywargs, &block)
      return super unless client.respond_to?(method)

      client.send(method, *args, **keywargs, &block)
    end
  else
    def self.method_missing(method, *args, &block)
      return super unless client.respond_to?(method)

      client.send(method, *args, &block)
    end
  end

  # Delegate to Gitlab::Client
  def self.respond_to_missing?(method_name, include_private = false)
    client.respond_to?(method_name) || super
  end

  # Delegate to HTTParty.http_proxy
  def self.http_proxy(address = nil, port = nil, username = nil, password = nil)
    Gitlab::Request.http_proxy(address, port, username, password)
  end

  # Returns an unsorted array of available client methods.
  #
  # @return [Array<Symbol>]
  def self.actions
    hidden =
      /endpoint|private_token|auth_token|user_agent|sudo|get|post|put|\Adelete\z|validate\z|request_defaults|httparty/
    (Gitlab::Client.instance_methods - Object.methods).reject { |e| e[hidden] }
  end
end
