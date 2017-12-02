module Gitlab
  # Wrapper for the Gitlab REST API.
  class Client < API
    Dir[File.expand_path('../client/*.rb', __FILE__)].each { |f| require f }

    # Please keep in alphabetical order
    include AwardEmojis
    include Boards
    include Branches
    include BuildVariables
    include Builds
    include Commits
    include Deployments
    include Environments
    include Groups
    include Issues
    include Jobs
    include Keys
    include Labels
    include MergeRequests
    include Milestones
    include Namespaces
    include Notes
    include PipelineSchedules
    include PipelineTriggers
    include Pipelines
    include Projects
    include Repositories
    include RepositoryFiles
    include Runners
    include Services
    include Snippets
    include SystemHooks
    include Tags
    include Todos
    include Users

    # Text representation of the client, masking private token.
    #
    # @return [String]
    def inspect
      inspected = super

      if @private_token
        inspected = inspected.sub! @private_token, only_show_last_four_chars(@private_token)
      end

      inspected
    end

    def url_encode(s)
      URI.encode(s.to_s, /\W/)
    end

    private

    def only_show_last_four_chars(token)
      "#{'*' * (token.size - 4)}#{token[-4..-1]}"
    end
  end
end
