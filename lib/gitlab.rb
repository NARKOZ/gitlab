require File.expand_path('../gitlab/version', __FILE__)
require File.expand_path('../gitlab/objectified_hash', __FILE__)
require File.expand_path('../gitlab/configuration', __FILE__)
require File.expand_path('../gitlab/error', __FILE__)
require File.expand_path('../gitlab/request', __FILE__)
require File.expand_path('../gitlab/api', __FILE__)
require File.expand_path('../gitlab/client', __FILE__)

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
