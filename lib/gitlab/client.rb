# frozen_string_literal: true

module Gitlab
  # Wrapper for the Gitlab REST API.
  class Client < API
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
    include Events
    include Features
    include GroupBoards
    include GroupLabels
    include GroupMilestones
    include Groups
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
    include Versions
    include Wikis

    # Text representation of the client, masking private token.
    #
    # @return [String]
    def inspect
      inspected = super
      inspected.sub! @private_token, only_show_last_four_chars(@private_token) if @private_token
      inspected
    end

    def url_encode(url)
      URI.encode(url.to_s, /\W/)
    end

    private

    def only_show_last_four_chars(token)
      "#{'*' * (token.size - 4)}#{token[-4..-1]}"
    end
  end
end
