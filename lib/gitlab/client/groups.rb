class Gitlab::Client
  # Defines methods related to groups.
  # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/groups.md
  module Groups
    # Gets a list of groups.
    #
    # @example
    #   Gitlab.groups
    #   Gitlab.groups({ per_page: 40, page: 2 })
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def groups(options={})
      get("/groups", query: options)
    end

    # Gets a single group.
    #
    # @example
    #   Gitlab.group(42)
    #
    # @param  [Integer] id The ID of a group.
    # @return [Gitlab::ObjectifiedHash]
    def group(id)
      get("/groups/#{id}")
    end

    # Creates a new group.
    #
    # @example
    #   Gitlab.create_group('new-group', 'group-path')
    #   Gitlab.create_group('gitlab', 'gitlab-path', { description: 'New Gitlab project' })
    #
    # @param  [String] name The name of a group.
    # @param  [String] path The path of a group.
    # @return [Gitlab::ObjectifiedHash] Information about created group.
    def create_group(name, path, options={})
      body = { name: name, path: path }.merge(options)
      post("/groups", body: body)
    end

    # Delete's a group.
    #
    # @example
    #   Gitlab.delete_group(42)
    # @param  [Integer] id The ID of a group
    # @return [Gitlab::ObjectifiedHash] Information about the deleted group.
    def delete_group(id)
      delete("/groups/#{id}")
    end

    # Get a list of group members.
    #
    # @example
    #   Gitlab.group_members(1)
    #   Gitlab.group_members(1, { per_page: 40 })
    #
    # @param  [Integer] id The ID of a group.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def group_members(id, options={})
      get("/groups/#{id}/members", query: options)
    end

    # Adds a user to group.
    #
    # @example
    #   Gitlab.add_group_member(1, 2, 40)
    #
    # @param  [Integer] team_id The group id to add a member to.
    # @param  [Integer] user_id The user id of the user to add to the team.
    # @param  [Integer] access_level Project access level.
    # @return [Gitlab::ObjectifiedHash] Information about added team member.
    def add_group_member(team_id, user_id, access_level)
      post("/groups/#{team_id}/members", body: { user_id: user_id, access_level: access_level })
    end

    # Edit a user of a group.
    #
    # @example
    #   Gitlab.edit_group_member(1, 2, 40)
    #
    # @param  [Integer] team_id The group id of member to edit.
    # @param  [Integer] user_id The user id of the user to edit.
    # @param  [Integer] access_level Project access level.
    # @return [Gitlab::ObjectifiedHash] Information about edited team member.
    def edit_group_member(team_id, user_id, access_level)
      put("/groups/#{team_id}/members/#{user_id}", body: { access_level: access_level })
    end

    # Removes user from user group.
    #
    # @example
    #   Gitlab.remove_group_member(1, 2)
    #
    # @param  [Integer] team_id The group ID.
    # @param  [Integer] user_id The ID of a user.
    # @return [Gitlab::ObjectifiedHash] Information about removed team member.
    def remove_group_member(team_id, user_id)
      delete("/groups/#{team_id}/members/#{user_id}")
    end

    # Transfers a project to a group
    #
    # @example
    #   Gitlab.transfer_project_to_group(3, 50)
    #
    # @param  [Integer] id The ID of a group.
    # @param  [Integer] project_id The ID of a project.
    def transfer_project_to_group(id, project_id)
      body = { id: id, project_id: project_id }
      post("/groups/#{id}/projects/#{project_id}", body: body)
    end

    # Search for groups by name
    #
    # @example
    #   Gitlab.group_search('gitlab')
    #
    # @param  [String] search A string to search for in group names and paths.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :per_page Number of projects to return per page
    # @option options [String] :page The page to retrieve
    # @return [Array<Gitlab::ObjectifiedHash>]
    def group_search(search, options={})
      options[:search] = search
      get("/groups", query: options)
    end

    # Get a list of projects under a group
    # @example
    #   Gitlab.group_projects(1)
    #
    # @param [Integer] id The ID of a group
    # @return [Array<Gitlab::ObjectifiedHash>] List of projects under a group
    def group_projects(id, options={})
      get("/groups/#{id}/projects", query: options)
    end
  end
end
