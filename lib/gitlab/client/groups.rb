class Gitlab::Client
  # Defines methods related to groups.
  module Groups

    # Gets a list of groups.
    #
    # @example
    #   Gitlab.groups
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def groups(options={})
      get("/groups", :query => options)
    end

    def group(group_id)
      get("/groups/#{group_id}")
    end

    # Creates a new group
    #
    # @param  [String] name
    # @param  [String] path
    def create_group(name, path)
      body = {:name => name, :path => path}
      post("/groups", :body => body)
    end

    # Transfers a project to a group
    #
    # @param  [Integer] group_id
    # @param  [Integer] project_id
    def transfer_project_to_group(group_id, project_id)
      body = {:id => group_id, :project_id => project_id}
      post("/groups/#{group_id}/projects/#{project_id}", :body => body)
    end
  end
end
