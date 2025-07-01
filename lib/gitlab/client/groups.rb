# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to groups.
  # @see https://docs.gitlab.com/ce/api/groups.html
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
    def groups(options = {})
      get('/groups', query: options)
    end

    # Gets a single group.
    #
    # @example
    #   Gitlab.group(42)
    #
    # @param  [Integer] id The ID of a group.
    # @param  [Hash] options A customizable set of options.
    # @option options [Boolean] :with_custom_attributes Include custom attributes in response (admins only)
    # @option options [Boolean] :with_projects Include details about group projects (default: true)
    # @return [Gitlab::ObjectifiedHash]
    def group(id, options = {})
      get("/groups/#{url_encode id}", query: options)
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
    def create_group(name, path, options = {})
      body = { name: name, path: path }.merge(options)
      post('/groups', body: body)
    end

    # Delete's a group.
    #
    # @example
    #   Gitlab.delete_group(42)
    # @param  [Integer] id The ID of a group
    # @return [Gitlab::ObjectifiedHash] Information about the deleted group.
    def delete_group(id)
      delete("/groups/#{url_encode id}")
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
    def group_members(id, options = {})
      get("/groups/#{url_encode id}/members", query: options)
    end

    # Gets a list of all group members including inherited members.
    #
    # @example
    #   Gitlab.all_group_members(1)
    #   Gitlab.all_group_members(1, { per_page: 40 })
    #
    # @param  [Integer] id The ID of a group.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def all_group_members(id, options = {})
      get("/groups/#{url_encode id}/members/all", query: options)
    end

    # Get a list of descendant groups of a group.
    #
    # @example
    #   Gitlab.group_descendants(42)
    #
    # @param [Integer] id the ID of a group
    # @param [Hash] options A customizable set of options.
    # @option options [String] :skip_groups Skip the group IDs passed.
    # @option options [String] :all_available Show all the groups you have access to (defaults to false for authenticated users).
    # @option options [String] :search Return the list of authorized groups matching the search criteria.
    # @option options [String] :order_by Order groups by name or path. Default is name.
    # @option options [String] :sort Order groups in asc or desc order. Default is asc.
    # @option options [String] :statistics Include group statistics (admins only).
    # @option options [String] :owned Limit to groups owned by the current user.
    # @return [Array<Gitlab::ObjectifiedHash>] List of all subgroups under a group
    def group_descendants(id, options = {})
      get("/groups/#{url_encode id}/descendant_groups", query: options)
    end

    # Get a list of group members that are billable.
    #
    # @example
    #   Gitlab.group_billable_members(1)
    #   Gitlab.group_billable_members(1, { per_page: 40 })
    #
    # @param  [Integer] id The ID of a group.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def group_billable_members(id, options = {})
      get("/groups/#{url_encode id}/billable_members", query: options)
    end

    # Get details of a single group member.
    #
    # @example
    #   Gitlab.group_member(1, 10)
    #
    # @param  [Integer] team_id The ID of the group to find a member in.
    # @param  [Integer] user_id The user id of the member to find.
    # @return [Gitlab::ObjectifiedHash] (id, username, name, email, state, access_level ...)
    def group_member(team_id, user_id)
      get("/groups/#{url_encode team_id}/members/#{user_id}")
    end

    # Gets a list of merge requests of a group.
    #
    # @example
    #   Gitlab.group_merge_requests(5)
    #
    # @param  [Integer, String] group_id The ID or name of a group.
    # @param  [Hash] options A customizable set of options.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def group_merge_requests(group, options = {})
      get("/groups/#{group}/merge_requests", query: options)
    end

    # Adds a user to group.
    #
    # @example
    #   Gitlab.add_group_member(1, 2, 40)
    #   Gitlab.add_group_member(1, 2, 40, member_role_id: 5)
    #
    # @param  [Integer] team_id The group id to add a member to.
    # @param  [Integer] user_id The user id of the user to add to the team.
    # @param  [Integer] access_level Project access level.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :member_role_id The id of a custom member role.
    # @return [Gitlab::ObjectifiedHash] Information about added team member.
    def add_group_member(team_id, user_id, access_level, options = {})
      body = { user_id: user_id, access_level: access_level }.merge(options)
      post("/groups/#{url_encode team_id}/members", body: body)
    end

    # Set LDAP override flag for a member of a group
    #
    # @example
    #   Gitlab.override_group_member(1, 2)
    #
    # @param  [Integer] team_id The group id into which LDAP syncs the user.
    # @param  [Integer] user_id The user id of the user.
    def override_group_member(team_id, user_id)
      post("/groups/#{url_encode team_id}/members/#{user_id}/override")
    end

    # Edit a user of a group.
    #
    # @example
    #   Gitlab.edit_group_member(1, 2, 40)
    #   Gitlab.edit_group_member(1, 2, 40, member_role_id: 5)
    #
    # @param  [Integer] team_id The group id of member to edit.
    # @param  [Integer] user_id The user id of the user to edit.
    # @param  [Integer] access_level Project access level.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :member_role_id The id of a custom member role.
    # @return [Gitlab::ObjectifiedHash] Information about edited team member.
    def edit_group_member(team_id, user_id, access_level, options = {})
      body = { access_level: access_level }.merge(options)
      put("/groups/#{url_encode team_id}/members/#{user_id}", body: body)
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
      delete("/groups/#{url_encode team_id}/members/#{user_id}")
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
      post("/groups/#{url_encode id}/projects/#{project_id}", body: body)
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
    def group_search(search, options = {})
      options[:search] = search
      get('/groups', query: options)
    end

    # Get a list of projects under a group
    # @example
    #   Gitlab.group_projects(1)
    #
    # @param [Integer] id The ID of a group
    # @return [Array<Gitlab::ObjectifiedHash>] List of projects under a group
    def group_projects(id, options = {})
      get("/groups/#{url_encode id}/projects", query: options)
    end

    # Get a list of subgroups under a group
    # @example
    #   Gitlab.group_subgroups(1)
    #
    # @param [Integer] id the ID of a group
    # @param [Hash] options A customizable set of options.
    # @option options [String] :skip_groups Skip the group IDs passed.
    # @option options [String] :all_available Show all the groups you have access to (defaults to false for authenticated users).
    # @option options [String] :search Return the list of authorized groups matching the search criteria.
    # @option options [String] :order_by Order groups by name or path. Default is name.
    # @option options [String] :sort Order groups in asc or desc order. Default is asc.
    # @option options [String] :statistics Include group statistics (admins only).
    # @option options [String] :owned Limit to groups owned by the current user.
    # @return [Array<Gitlab::ObjectifiedHash>] List of subgroups under a group
    def group_subgroups(id, options = {})
      get("/groups/#{url_encode id}/subgroups", query: options)
    end

    # Updates an existing group.
    #
    # @example
    #   Gitlab.edit_group(42)
    #   Gitlab.edit_group(42, { name: 'Group Name' })
    #
    # @param  [Integer] group The ID.
    # @param  [Hash] options A customizable set of options
    # @option options [String] :name The name of the group.
    # @option options [String] :path The path of the group.
    # @option options [String] :description The description of the group.
    # @option options [String] :visibility The visibility level of the group. Can be private, internal, or public
    # @option options [String] :lfs_enabled Enable/disable Large File Storage (LFS) for the projects in this groupr.
    # @option options [String] :request_access_enabled Allow users to request member access.
    # @return [Gitlab::ObjectifiedHash] Information about the edited group.
    def edit_group(id, options = {})
      put("/groups/#{url_encode id}", body: options)
    end

    # Gets a list of issues of a group.
    #
    # @example
    #   Gitlab.group_issues(5)
    #
    # @param  [Integer, String] group_id The ID or name of a group.
    # @param  [Hash] options A customizable set of options.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def group_issues(group, options = {})
      get("/groups/#{group}/issues", query: options)
    end

    # Sync group with LDAP
    #
    # @example
    #   Gitlab.sync_ldap_group(1)
    #
    # @param [Integer] id The ID or name of a group.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def sync_ldap_group(id)
      post("/groups/#{url_encode id}/ldap_sync")
    end

    # Add LDAP group link
    #
    # @example
    #   Gitlab.add_ldap_group_links(1, 'all', 50, 'ldap')
    #
    # @param  [Integer] id The ID of a group
    # @param  [String] cn The CN of a LDAP group
    # @param  [Integer] group_access Minimum access level for members of the LDAP group.
    # @param  [String] provider LDAP provider for the LDAP group
    # @return [Gitlab::ObjectifiedHash] Information about added ldap group link
    def add_ldap_group_links(id, commonname, group_access, provider)
      post("/groups/#{url_encode id}/ldap_group_links", body: { cn: commonname, group_access: group_access, provider: provider })
    end

    # Delete LDAP group link
    #
    # @example
    #   Gitlab.delete_ldap_group_links(1, 'all')
    #
    # @param  [Integer] id The ID of a group
    # @param  [String] cn The CN of a LDAP group
    # @return [Gitlab::ObjectifiedHash] Empty hash
    def delete_ldap_group_links(id, commonname, provider)
      delete("/groups/#{url_encode id}/ldap_group_links/#{url_encode provider}/#{url_encode commonname}")
    end

    # Gets group custom_attributes.
    #
    # @example
    #   Gitlab.group_custom_attributes(2)
    #
    # @param  [Integer] group_id The ID of a group.
    # @return [Gitlab::ObjectifiedHash]
    def group_custom_attributes(group_id)
      get("/groups/#{group_id}/custom_attributes")
    end

    # Gets single group custom_attribute.
    #
    # @example
    #   Gitlab.group_custom_attribute('key', 2)
    #
    # @param  [String] key The custom_attributes key
    # @param  [Integer] group_id The ID of a group.
    # @return [Gitlab::ObjectifiedHash]
    def group_custom_attribute(key, group_id)
      get("/groups/#{group_id}/custom_attributes/#{key}")
    end

    # Creates a new custom_attribute
    #
    # @example
    #   Gitlab.add_custom_attribute('some_new_key', 'some_new_value', 2)
    #
    # @param  [String] key The custom_attributes key
    # @param  [String] value The custom_attributes value
    # @param  [Integer] group_id The ID of a group.
    # @return [Gitlab::ObjectifiedHash]
    def add_group_custom_attribute(key, value, group_id)
      url = "/groups/#{group_id}/custom_attributes/#{key}"
      put(url, body: { value: value })
    end

    # Delete custom_attribute
    # Will delete a custom_attribute
    #
    # @example
    #   Gitlab.delete_group_custom_attribute('somekey', 2)
    #
    # @param  [String] key The custom_attribute key to delete
    # @param  [Integer] group_id The ID of a group.
    # @return [Boolean]
    def delete_group_custom_attribute(key, group_id = nil)
      delete("/groups/#{group_id}/custom_attributes/#{key}")
    end

    # List all the specified groups hooks
    #
    # @example
    #   Gitlab.list_group_hooks(3)
    #
    # @param  [Integer] group_id The ID of a group.
    # @return [Gitlab::PaginatedResponse] List of registered hooks https://docs.gitlab.com/ee/api/groups.html#hooks
    def list_group_hooks(group_id)
      get("/groups/#{group_id}/hooks")
    end

    # get specified group hook
    #
    # @example
    #   Gitlab.group_hook(3, 1)
    #
    # @param  [Integer] group_id The ID of a group.
    # @param  [Integer] hook_id The ID of the hook.
    # @return [Gitlab::ObjectifiedHash] The hook https://docs.gitlab.com/ee/api/groups.html#get-group-hook
    def group_hook(group_id, hook_id)
      get("/groups/#{group_id}/hooks/#{hook_id}")
    end

    # Add a new group hook
    #
    # @example
    #   Gitlab.add_group_hook(3, "https://example.com/my-hook-receiver", {token: "verify me"})
    #
    # @param  [Integer] group_id The ID of a group.
    # @param  [String] the hook url which will receive the selected events
    # @option options [Boolean] :name The name of the group.
    # @option options [Boolean] :push_events Trigger hook on push events
    # @potion options [String] :push_events_branch_filter	Trigger hook on push events for matching branches only.
    # @option options [Boolean] :issues_events Trigger hook on issues events
    # @option options [Boolean] :confidential_issues_events Trigger hook on confidential issues events
    # @option options [Boolean] :merge_requests_events Trigger hook on merge requests events
    # @option options [Boolean] :tag_push_events Trigger hook on tag push events
    # @option options [Boolean] :note_events Trigger hook on note events
    # @option options [Boolean] :confidential_note_events Trigger hook on confidential note events
    # @option options [Boolean] :job_events Trigger hook on job events
    # @option options [Boolean] :pipeline_events Trigger hook on pipeline events
    # @option options [Boolean] :wiki_page_events Trigger hook on wiki page events
    # @option options [Boolean] :deployment_events Trigger hook on deployment events
    # @option options [Boolean] :releases_events Trigger hook on release events
    # @option options [Boolean] :subgroup_events Trigger hook on subgroup events
    # @option options [Boolean] :enable_ssl_verification Do SSL verification when triggering the hook
    # @option options [String] :token	Secret token to validate received payloads; not returned in the response
    # @return [Gitlab::ObjectifiedHash] Response body matches https://docs.gitlab.com/ee/api/groups.html#get-group-hook
    def add_group_hook(group_id, url, options = {})
      post("/groups/#{group_id}/hooks", body: options.merge(url: url))
    end

    # Edit a group hook
    #
    # @example
    #   Gitlab.edit_group_hook(3, 1, "https://example.com/my-hook-receiver", {token: "verify me"})
    #
    # @param  [Integer] group_id The ID of a group.
    # @param  [Integer] hook_id The ID of a group.
    # @param  [String] the hook url which will receive the selected events
    # @option options [Boolean] :name The name of the group.
    # @option options [Boolean] :push_events Trigger hook on push events
    # @potion options [String] :push_events_branch_filter	Trigger hook on push events for matching branches only.
    # @option options [Boolean] :issues_events Trigger hook on issues events
    # @option options [Boolean] :confidential_issues_events Trigger hook on confidential issues events
    # @option options [Boolean] :merge_requests_events Trigger hook on merge requests events
    # @option options [Boolean] :tag_push_events Trigger hook on tag push events
    # @option options [Boolean] :note_events Trigger hook on note events
    # @option options [Boolean] :confidential_note_events Trigger hook on confidential note events
    # @option options [Boolean] :job_events Trigger hook on job events
    # @option options [Boolean] :pipeline_events Trigger hook on pipeline events
    # @option options [Boolean] :wiki_page_events Trigger hook on wiki page events
    # @option options [Boolean] :deployment_events Trigger hook on deployment events
    # @option options [Boolean] :releases_events Trigger hook on release events
    # @option options [Boolean] :subgroup_events Trigger hook on subgroup events
    # @option options [Boolean] :enable_ssl_verification Do SSL verification when triggering the hook
    # @option options [String] :token	Secret token to validate received payloads; not returned in the response
    # @return [Gitlab::ObjectifiedHash] Response body matches https://docs.gitlab.com/ee/api/groups.html#edit-group-hook
    def edit_group_hook(group_id, hook_id, url, options = {})
      post("/groups/#{group_id}/hooks/#{hook_id}", body: options.merge(url: url))
    end

    # Delete a group hook
    #
    # @example
    #   Gitlab.delete_group_hook(3, 1)
    #
    # @param  [Integer] group_id The ID of a group.
    # @param  [Integer] hook_id The ID of a group.
    # @return [Gitlab::ObjectifiedHash] no body, will evaluate to an empty hash. https://docs.gitlab.com/ee/api/groups.html#delete-group-hook
    def delete_group_hook(group_id, hook_id)
      delete("/groups/#{group_id}/hooks/#{hook_id}")
    end
  end

  # Get all access tokens for a group
  #
  # @example
  #   Gitlab.group_access_tokens(1)
  #
  # @param  [Integer] group_id The ID of the group.
  # @return [Array<Gitlab::ObjectifiedHash>]
  def group_access_tokens(group_id)
    get("/groups/#{group_id}/access_tokens")
  end

  # Get group access token information
  #
  # @example
  #   Gitlab.group_access_token(1, 1)
  #
  # @param  [Integer] group_id The ID of the group.
  # @param  [Integer] group_access_token_id ID of the group access token.
  # @return [Gitlab::ObjectifiedHash]
  def group_access_token(group_id, group_access_token_id)
    get("/groups/#{group_id}/access_tokens/#{group_access_token_id}")
  end

  # Create group access token
  #
  # @example
  #   Gitlab.create_group_access_token(2, "token", ["api", "read_user"])
  #   Gitlab.create_group_access_token(2, "token", ["api", "read_user"], 20)
  #   Gitlab.create_group_access_token(2, "token", ["api", "read_user"], 20, "1970-01-01")
  #
  # @param  [Integer] group_id The ID of the group.
  # @param  [String] name Name for group access token.
  # @param  [Array<String>] scopes Array of scopes for the group access token
  # @param  [Integer] access_level Project access level (10: Guest, 20: Reporter, 30: Developer, 40: Maintainer, 50: Owner).
  # @param  [String] expires_at Date for group access token expiration in ISO format.
  # @return [Gitlab::ObjectifiedHash]
  def create_group_access_token(group_id, name, scopes, access_level = nil, expires_at = nil)
    body = { name: name, scopes: scopes }
    body[:access_level] = access_level if access_level
    body[:expires_at] = expires_at if expires_at
    post("/groups/#{group_id}/access_tokens", body: body)
  end

  # Revoke a group access token
  #
  # @example
  #   Gitlab.revoke_group_access_token(1, 1)
  #
  # @param  [Integer] user_id The ID of the group.
  # @param  [Integer] group_access_token_id ID of the group access token.
  # @return [Gitlab::ObjectifiedHash]
  def revoke_group_access_token(group_id, group_access_token_id)
    delete("/groups/#{group_id}/access_tokens/#{group_access_token_id}")
  end
end
