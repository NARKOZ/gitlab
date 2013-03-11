class Gitlab::Client
  # Defines methods related to groups.
  module Groups

    def groups
      get("/groups")
    end

    def group(group_id)
      get("/groups/#{group_id}")
    end

    #Creates a new group
    #
    # @param  [String] name
    # @param  [String] path
    def create_group(name, path)
      body = {:name => name, :path => path}
      post("/groups", :body => body)
    end

    #Transfers a project to a group
    #
    # @param  [Integer] group_id
    # @param  [Integer] project_id
    def transfer_project_to_group(group_id, project_id)
      body = {:id => group_id, :project_id => project_id}
      post("/groups/#{group_id}/projects/#{project_id}", :body => body)
    end


    # Creates a new issue.
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [String] title The title of an issue.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :description The description of an issue.
    # @option options [Integer] :assignee_id The ID of a user to assign issue.
    # @option options [Integer] :milestone_id The ID of a milestone to assign issue.
    # @option options [String] :labels Comma-separated label names for an issue.
    # @return [Gitlab::ObjectifiedHash] Information about created issue.
=begin
    def create_issue(project, title, options={})
      body = {:title => title}.merge(options)
      post("/projects/#{project}/issues", :body => body)
    end
=end


  end
end