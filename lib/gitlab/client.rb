module Gitlab
  # Wrapper for the Gitlab REST API.
  class Client < API
    Dir[File.expand_path('../client/*.rb', __FILE__)].each { |f| require f }

    include Branches
    include Builds
    include BuildTriggers
    include Commits
    include Groups
    include Issues
    include Labels
    include MergeRequests
    include Milestones
    include Namespaces
    include Notes
    include Projects
    include Repositories
    include RepositoryFiles
    include Services
    include Snippets
    include SystemHooks
    include Users
  end
end
