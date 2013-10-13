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

    # Get a list of group members.
    #
    # @example
    #   Gitlab.group_members(1)
    #
    # @param  [Integer] (required) - The ID of a group
    # @return [Gitlab::ObjectifiedHash]
    def group_members(id)
      get("/groups/#{id}/members")
    end

    # Adds a user to group.
    #
    # @example
    #   Gitlab.add_group_member(1, 2, 40)
    #
    # @param  [Integer] (required) The group id to add a member to
    # @param  [Integer] (required) The user id of the user to add to the team
    # @param  [Integer] (required) access_level Project access level
    # @return [Array<Gitlab::ObjectifiedHash>] Information about added team member.
    def add_group_member(team_id, user_id, access_level)
      post("/groups/#{team_id}/members", :body => {:user_id => user_id, :access_level => access_level})
    end

    # Removes user from user group.
    #
    # @example
    #   Gitlab.remove_group_member(1, 2)
    #
    # @param  [Integer] (required) The group ID.
    # @param  [Integer] (required) id The ID of a user.
    # @return [Array<Gitlab::ObjectifiedHash>] Information about removed team member.
    def remove_group_member(team_id, user_id)
      delete("/groups/#{team_id}/members/#{user_id}")
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
