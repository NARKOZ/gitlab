# frozen_string_literal: true

require 'gitlab/configuration'

module Gitlab
  # Wrapper for the Gitlab REST API.
  class Client < API
    extend Configuration

    Dir[File.expand_path('client/*.rb', __dir__)].each { |f| require f }

    # Please keep in alphabetical order
    include AccessRequests
    include ApplicationSettings
    include Avatar
    include AwardEmojis
    include Boards
    include Branches
    include BroadcastMessages
    include BuildVariables
    include Builds
    include Commits
    include ContainerRegistry
    include Deployments
    include Environments
    include EpicIssues
    include Epics
    include Events
    include Features
    include GroupBadges
    include GroupBoards
    include GroupLabels
    include GroupMilestones
    include Groups
    include IssueLinks
    include Issues
    include Jobs
    include Keys
    include Labels
    include Lint
    include Markdown
    include MergeRequestApprovals
    include MergeRequests
    include Milestones
    include Namespaces
    include Notes
    include PipelineSchedules
    include PipelineTriggers
    include Pipelines
    include ProjectBadges
    include ProjectClusters
    include ProjectReleaseLinks
    include ProjectReleases
    include Projects
    include ProtectedTags
    include Repositories
    include RepositoryFiles
    include RepositorySubmodules
    include ResourceLabelEvents
    include ResourceStateEvents
    include Runners
    include Search
    include Services
    include Sidekiq
    include Snippets
    include SystemHooks
    include Tags
    include Templates
    include Todos
    include Users
    include UserSnippets
    include Versions
    include Wikis

    # Alias for Gitlab::Client.new
    #
    # @return [Gitlab::Client]
    def self.client(options = {})
      Gitlab::Client.new(options)
    end

    # Text representation of the client, masking private token.
    #
    # @return [String]
    def inspect
      inspected = super
      inspected.sub! @private_token, only_show_last_four_chars(@private_token) if @private_token
      inspected
    end

    # Utility method for URL encoding of a string.
    # Copied from https://ruby-doc.org/stdlib-2.7.0/libdoc/erb/rdoc/ERB/Util.html
    #
    # @return [String]
    def url_encode(url)
      url.to_s.b.gsub(/[^a-zA-Z0-9_\-.~]/n) { |m| sprintf('%%%02X', m.unpack1('C')) } # rubocop:disable Style/FormatString
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

    # Delegate to Gitlab::Client
    # @deprecated To be removed from [Gitlab] and accessed only from [Gitlab::Client]
    def self.method_missing(method, *args, &block)
      if Gitlab::Client.client.respond_to?(method)
        Gitlab::Client.client.send(method, *args, &block)
      else
        super
      end
    end

    # Delegate to Gitlab::Client
    def self.respond_to_missing?(method_name, include_private = false)
      Gitlab::Client.client.respond_to?(method_name, include_private) || super
    end

    private

    def only_show_last_four_chars(token)
      "#{'*' * (token.size - 4)}#{token[-4..-1]}"
    end
  end
end
