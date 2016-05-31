class Gitlab::Client
  # Defines methods related to projects.
  # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/projects.md
  module Projects
    # Gets a list of projects owned by the authenticated user.
    #
    # @example
    #   Gitlab.projects
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @option options [String] :scope Scope of projects. 'owned' for list of projects owned by the authenticated user, 'all' to get all projects (admin only)
    # @return [Array<Gitlab::ObjectifiedHash>]
    def projects(options={})
      if options[:scope]
        get("/projects/#{options[:scope]}", query: options)
      else
        get("/projects", query: options)
      end
    end

    # Search for projects by name.
    #
    # @example
    #   Gitlab.project_search('gitlab')
    #   Gitlab.project_search('gitlab', { order_by: 'last_activity_at' })
    #   Gitlab.search_projects('gitlab', { order_by: 'name', sort: 'asc' })
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :per_page Number of projects to return per page
    # @option options [String] :page The page to retrieve
    # @option options [String] :order_by Return requests ordered by id, name, created_at or last_activity_at fields
    # @option options [String] :sort Return requests sorted in asc or desc order
    # @return [Array<Gitlab::ObjectifiedHash>]
    def project_search(query, options={})
      get("/projects/search/#{query}", query: options)
    end
    alias_method :search_projects, :project_search

    # Gets information about a project.
    #
    # @example
    #   Gitlab.project(3)
    #   Gitlab.project('gitlab')
    #
    # @param  [Integer, String] id The ID or name of a project.
    # @return [Gitlab::ObjectifiedHash]
    def project(id)
      get("/projects/#{id}")
    end

    # Gets a list of project events.
    #
    # @example
    #   Gitlab.project_events(42)
    #   Gitlab.project_events('gitlab')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def project_events(project, options={})
      get("/projects/#{project}/events", query: options)
    end

    # Creates a new project.
    #
    # @example
    #   Gitlab.create_project('gitlab')
    #   Gitlab.create_project('viking', { description: 'Awesome project' })
    #   Gitlab.create_project('Red', { wall_enabled: false })
    #
    # @param  [String] name The name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :description The description of a project.
    # @option options [String] :default_branch The default branch of a project.
    # @option options [String] :namespace_id The namespace in which to create a project.
    # @option options [Boolean] :wiki_enabled The wiki integration for a project (0 = false, 1 = true).
    # @option options [Boolean] :wall_enabled The wall functionality for a project (0 = false, 1 = true).
    # @option options [Boolean] :issues_enabled The issues integration for a project (0 = false, 1 = true).
    # @option options [Boolean] :snippets_enabled The snippets integration for a project (0 = false, 1 = true).
    # @option options [Boolean] :merge_requests_enabled The merge requests functionality for a project (0 = false, 1 = true).
    # @option options [Boolean] :public The setting for making a project public (0 = false, 1 = true).
    # @option options [Integer] :user_id The user/owner id of a project.
    # @return [Gitlab::ObjectifiedHash] Information about created project.
    def create_project(name, options={})
      url = options[:user_id] ? "/projects/user/#{options[:user_id]}" : "/projects"
      post(url, body: { name: name }.merge(options))
    end

    # Deletes a project.
    #
    # @example
    #   Gitlab.delete_project(4)
    #
    # @param  [Integer, String] id The ID or name of a project.
    # @return [Gitlab::ObjectifiedHash] Information about deleted project.
    def delete_project(id)
      delete("/projects/#{id}")
    end

    # Gets a list of project team members.
    #
    # @example
    #   Gitlab.team_members(42)
    #   Gitlab.team_members('gitlab')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :query The search query.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def team_members(project, options={})
      get("/projects/#{project}/members", query: options)
    end

    # Gets a project team member.
    #
    # @example
    #   Gitlab.team_member('gitlab', 2)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a project team member.
    # @return [Gitlab::ObjectifiedHash]
    def team_member(project, id)
      get("/projects/#{project}/members/#{id}")
    end

    # Adds a user to project team.
    #
    # @example
    #   Gitlab.add_team_member('gitlab', 2, 40)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a user.
    # @param  [Integer] access_level The access level to project.
    # @param  [Hash] options A customizable set of options.
    # @return [Gitlab::ObjectifiedHash] Information about added team member.
    def add_team_member(project, id, access_level)
      post("/projects/#{project}/members", body: { user_id: id, access_level: access_level })
    end

    # Updates a team member's project access level.
    #
    # @example
    #   Gitlab.edit_team_member('gitlab', 3, 20)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a user.
    # @param  [Integer] access_level The access level to project.
    # @param  [Hash] options A customizable set of options.
    # @return [Array<Gitlab::ObjectifiedHash>] Information about updated team member.
    def edit_team_member(project, id, access_level)
      put("/projects/#{project}/members/#{id}", body: { access_level: access_level })
    end

    # Removes a user from project team.
    #
    # @example
    #   Gitlab.remove_team_member('gitlab', 2)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a user.
    # @param  [Hash] options A customizable set of options.
    # @return [Gitlab::ObjectifiedHash] Information about removed team member.
    def remove_team_member(project, id)
      delete("/projects/#{project}/members/#{id}")
    end

    # Gets a list of project hooks.
    #
    # @example
    #   Gitlab.project_hooks(42)
    #   Gitlab.project_hooks('gitlab')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def project_hooks(project, options={})
      get("/projects/#{project}/hooks", query: options)
    end

    # Gets a project hook.
    #
    # @example
    #   Gitlab.project_hook(42, 5)
    #   Gitlab.project_hook('gitlab', 5)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a hook.
    # @return [Gitlab::ObjectifiedHash]
    def project_hook(project, id)
      get("/projects/#{project}/hooks/#{id}")
    end

    # Adds a new hook to the project.
    #
    # @example
    #   Gitlab.add_project_hook(42, 'https://api.example.net/v1/webhooks/ci')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] url The hook URL.
    # @param  [Hash] options A customizable set of options.
    # @param  option [Boolean] :push_events Trigger hook on push events (0 = false, 1 = true)
    # @param  option [Boolean] :issues_events Trigger hook on issues events (0 = false, 1 = true)
    # @param  option [Boolean] :merge_requests_events Trigger hook on merge_requests events (0 = false, 1 = true)
    # @param  option [Boolean] :tag_push_events Trigger hook on push_tag events (0 = false, 1 = true)
    # @return [Gitlab::ObjectifiedHash] Information about added hook.
    def add_project_hook(project, url, options={})
      body = { url: url }.merge(options)
      post("/projects/#{project}/hooks", body: body)
    end

    # Updates a project hook URL.
    #
    # @example
    #   Gitlab.edit_project_hook(42, 1, 'https://api.example.net/v1/webhooks/ci')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of the hook.
    # @param  [String] url The hook URL.
    # @param  [Hash] options A customizable set of options.
    # @param  option [Boolean] :push_events Trigger hook on push events (0 = false, 1 = true)
    # @param  option [Boolean] :issues_events Trigger hook on issues events (0 = false, 1 = true)
    # @param  option [Boolean] :merge_requests_events Trigger hook on merge_requests events (0 = false, 1 = true)
    # @param  option [Boolean] :tag_push_events Trigger hook on push_tag events (0 = false, 1 = true)
    # @return [Gitlab::ObjectifiedHash] Information about updated hook.
    def edit_project_hook(project, id, url, options={})
      body = { url: url }.merge(options)
      put("/projects/#{project}/hooks/#{id}", body: body)
    end

    # Deletes a hook from project.
    #
    # @example
    #   Gitlab.delete_project_hook('gitlab', 4)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] id The ID of the hook.
    # @return [Gitlab::ObjectifiedHash] Information about deleted hook.
    def delete_project_hook(project, id)
      delete("/projects/#{project}/hooks/#{id}")
    end

    # Gets a project git hook.
    # See: http://docs.gitlab.com/ee/api/projects.html#show-project-git-hooks
    #
    # @example
    #   Gitlab.git_hook(42)
    #
    # @param  [Integer] id The ID of a project.
    # @return [Gitlab::ObjectifiedHash]
    def git_hook(id)
      get("/projects/#{id}/git_hook")
    end

    # Adds a project git hook.
    # See: http://docs.gitlab.com/ee/api/projects.html#add-project-git-hook
    #
    # @example
    #   Gitlab.add_git_hook(42, { deny_delete_tag: false, commit_message_regex: '\\b[A-Z]{3}-[0-9]+\\b' })
    #
    # @param  [Integer] id The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @param  option [Boolean] :deny_delete_tag Do not allow users to remove git tags with git push (0 = false, 1 = true)
    # @param  option [String] :commit_message_regex Commit message regex
    # @return [Gitlab::ObjectifiedHash] Information about added git hook.
    def add_git_hook(id, options={})
      post("/projects/#{id}/git_hook", body: options)
    end

    # Updates a project git hook.
    # See: http://docs.gitlab.com/ee/api/projects.html#edit-project-git-hook
    #
    # @example
    #   Gitlab.edit_git_hook(42, { deny_delete_tag: false, commit_message_regex: '\\b[A-Z]{3}-[0-9]+\\b' })
    #
    # @param  [Integer] id The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @param  option [Boolean] :deny_delete_tag Do not allow users to remove git tags with git push (0 = false, 1 = true)
    # @param  option [String] :commit_message_regex Commit message regex
    # @return [Gitlab::ObjectifiedHash] Information about updated git hook.
    def edit_git_hook(id, options={})
      put("/projects/#{id}/git_hook", body: options)
    end

    # Deletes a git hook from a project.
    # See: http://docs.gitlab.com/ee/api/projects.html#delete-project-git-hook
    #
    # @example
    #   Gitlab.delete_git_hook(42)
    #
    # @param  [Integer] id The ID of a project.
    # @return [Gitlab::ObjectifiedHash] Information about deleted git hook.
    def delete_git_hook(id, options={})
      delete("/projects/#{id}/git_hook")
    end

    # Mark this project as forked from the other
    #
    # @example
    #   Gitlab.make_forked(42, 24)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of the project it is forked from.
    # @return [Gitlab::ObjectifiedHash] Information about the forked project.
    def make_forked_from(project, id)
      post("/projects/#{project}/fork/#{id}")
    end

    # Remove a forked_from relationship for a project.
    #
    # @example
    #  Gitlab.remove_forked(42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] project The ID of the project it is forked from
    # @return [Gitlab::ObjectifiedHash] Information about the forked project.
    def remove_forked(project)
      delete("/projects/#{project}/fork")
    end

    # Gets a project deploy keys.
    #
    # @example
    #   Gitlab.deploy_keys(42)
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def deploy_keys(project, options={})
      get("/projects/#{project}/keys", query: options)
    end

    # Gets a single project deploy key.
    #
    # @example
    #   Gitlab.deploy_key(42, 1)
    #
    # @param  [Integer, String] project The ID of a project.
    # @param  [Integer] id The ID of a deploy key.
    # @return [Gitlab::ObjectifiedHash]
    def deploy_key(project, id)
      get("/projects/#{project}/keys/#{id}")
    end

    # Creates a new deploy key.
    #
    # @example
    #   Gitlab.create_deploy_key(42, 'My Key', 'Key contents')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] title The title of a deploy key.
    # @param  [String] key The content of a deploy key.
    # @return [Gitlab::ObjectifiedHash] Information about created deploy key.
    def create_deploy_key(project, title, key)
      post("/projects/#{project}/keys", body: { title: title, key: key })
    end

    # Deletes a deploy key from project.
    #
    # @example
    #   Gitlab.delete_deploy_key(42, 1)
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Integer] id The ID of a deploy key.
    # @return [Gitlab::ObjectifiedHash] Information about deleted deploy key.
    def delete_deploy_key(project, id)
      delete("/projects/#{project}/keys/#{id}")
    end

    # Forks a project into the user namespace.
    #
    # @example
    #   Gitlab.create_fork(42)
    #   Gitlab.create_fork(42, { sudo: 'another_username' })
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :sudo The username the project will be forked for
    # @return [Gitlab::ObjectifiedHash] Information about the forked project.
    def create_fork(id, options={})
      post("/projects/fork/#{id}", body: options)
    end

    # Updates an existing project.
    #
    # @example
    #   Gitlab.edit_project(42)
    #   Gitlab.edit_project(42, { name: 'project_name' })
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :name The name of a project
    # @option options [String] :path The name of a project
    # @option options [String] :description The name of a project
    # @return [Gitlab::ObjectifiedHash] Information about the edited project.
    def edit_project(id, options={})
      put("/projects/#{id}", query: options)
    end
  end
end
