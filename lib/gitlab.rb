require 'gitlab/version'
require 'gitlab/objectified_hash'
require 'gitlab/configuration'
require 'gitlab/error'
require 'gitlab/request'
require 'gitlab/api'
require 'gitlab/client'

module Gitlab
  extend Configuration

  # Alias for Gitlab::Client.new
  #
  # @return [Gitlab::Client]
  def self.client(options={})
    Gitlab::Client.new(options)
  end

  # Delegate to Gitlab::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to Gitlab::Client
  def self.respond_to?(method)
    return client.respond_to?(method) || super
  end
end
