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
  # Delegate to Gitlab::Client
  # @deprecated To be removed from [Gitlab] and accessed only from [Gitlab::Client]
  def self.method_missing(method, *args, &block)
    if Gitlab::Client.respond_to?(method)
      Gitlab::Client.send(method, *args, &block)
    elsif Gitlab::Client.client.respond_to?(method)
      Gitlab::Client.client.send(method, *args, &block)
    else
      super
    end
  end

  # Delegate to Gitlab::Client
  # @deprecated To be removed from [Gitlab] and accessed only from [Gitlab::Client]
  def self.respond_to_missing?(method_name, include_private = false)
    Gitlab::Client.respond_to?(method_name, include_private) ||
      Gitlab::Client.client.respond_to?(method_name, include_private) || super
  end
end
