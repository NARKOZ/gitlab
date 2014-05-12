module Gitlab
  # Wrapper for the Gitlab REST API.
  class Client < API
    Dir[File.expand_path('../client/*.rb', __FILE__)].each {|f| require f}

    include Branches
    include Groups
    include Issues
    include MergeRequests
    include Milestones
    include Notes
    include Projects
    include Repositories
    include Snippets
    include SystemHooks
    include Users
  end
end
