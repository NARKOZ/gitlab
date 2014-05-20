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

  # Returns an unsorted array of available client methods.
  #
  # @return [Array<Symbol>]
  def self.actions
    hidden = /endpoint|private_token|user_agent|sudo|get|post|put|\Adelete\z|validate|set_request_defaults/
    (Gitlab::Client.instance_methods - Object.methods).reject {|e| e[hidden]}
  end
end
