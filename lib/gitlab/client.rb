module Gitlab
  # Wrapper for the Gitlab REST API.
  class Client < API
    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}

    include Gitlab::Client::Users
    include Gitlab::Client::Issues
    include Gitlab::Client::Milestones
    include Gitlab::Client::Snippets
    include Gitlab::Client::Projects
    include Gitlab::Client::Repositories
    include Gitlab::Client::MergeRequests
  end
end
