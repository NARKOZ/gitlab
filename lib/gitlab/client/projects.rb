class Gitlab::Client
  # Defines methods related to projects.
  module Projects
    # Gets a list of projects owned by the authenticated user.
    #
    # @example
    #   Gitlab.projects
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def projects(options={})
      get("/projects", :query => options)
    end

    # Gets information about a project.
    #
    # @example
    #   Gitlab.project(3)
    #   Gitlab.project('gitlab')
    #
    # @param  [Integer, String] id The ID or code name of a project.
    # @return [Gitlab::ObjectifiedHash]
    def project(id)
      get("/projects/#{id}")
    end

    # Creates a new project.
    #
    # @example
    #   Gitlab.create_project('gitlab')
    #   Gitlab.create_project('viking', :description => 'Awesome project')
    #   Gitlab.create_project('Red', :wall_enabled => false)
    #
    # @param  [String] name The name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :code The code name of a project.
    # @option options [String] :path The path of a project.
    # @option options [String] :description The description of a project.
    # @option options [String] :default_branch The default branch of a project.
    # @option options [Boolean] :wiki_enabled The wiki integration for a project (0 = false, 1 = true).
    # @option options [Boolean] :wall_enabled The wall functionality for a project (0 = false, 1 = true).
    # @option options [Boolean] :issues_enabled The issues integration for a project (0 = false, 1 = true).
    # @option options [Boolean] :merge_requests_enabled The merge requests functionality for a project (0 = false, 1 = true).
    # @return [Gitlab::ObjectifiedHash] Information about created project.
    def create_project(name, options={})
      post("/projects", :body => {:name => name}.merge(options))
    end



    # Creates a new project for a user, Available only for admins.
    #
    # @example
    #   Gitlab.create_project('gitlab','user_id')
    #   Gitlab.create_project('viking','user_id', :description => 'Awesome project')
    #   Gitlab.create_project('Red', 'user_id', :wall_enabled => false)
    #
    # @param  [String] name The name of a project.
    # @param  [String] user_id The user_id of the projects owner
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :code The code name of a project.
    # @option options [String] :path The path of a project.
    # @option options [String] :description The description of a project.
    # @option options [String] :default_branch The default branch of a project.
    # @option options [Boolean] :wiki_enabled The wiki integration for a project (0 = false, 1 = true).
    # @option options [Boolean] :wall_enabled The wall functionality for a project (0 = false, 1 = true).
    # @option options [Boolean] :issues_enabled The issues integration for a project (0 = false, 1 = true).
    # @option options [Boolean] :merge_requests_enabled The merge requests functionality for a project (0 = false, 1 = true).
    # @return [Gitlab::ObjectifiedHash] Information about created project.
    def create_project_for_user(name, user_id, options={})
      post("/projects/user/#{user_id}", :body => {:name => name}.merge(options))
    end

    # Gets a list of project team members.
    #
    # @example
    #   Gitlab.team_members(42)
    #   Gitlab.team_members('gitlab')
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def team_members(project, options={})
      get("/projects/#{project}/members", :query => options)
    end

    # Gets a project team member.
    #
    # @example
    #   Gitlab.team_member('gitlab', 2)
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Integer] id The ID of a project team member.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def team_member(project, id)
      get("/projects/#{project}/members/#{id}")
    end

    # Adds a user to project team.
    #
    # @example
    #   Gitlab.add_team_member('gitlab', 2, 40)
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Integer] id The ID of a user.
    # @param  [Integer] access_level The access level to project.
    # @return [Array<Gitlab::ObjectifiedHash>] Information about added team member.
    def add_team_member(project, id, access_level)
      post("/projects/#{project}/members", :body => {:user_id => id, :access_level => access_level})
    end

    # Updates a team member's project access level.
    #
    # @example
    #   Gitlab.edit_team_member('gitlab', 3, 20)
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Integer] id The ID of a user.
    # @param  [Integer] access_level The access level to project.
    # @return [Array<Gitlab::ObjectifiedHash>] Information about updated team member.
    def edit_team_member(project, id, access_level)
      put("/projects/#{project}/members/#{id}", :body => {:access_level => access_level})
    end

    # Removes a user from project team.
    #
    # @example
    #   Gitlab.remove_team_member('gitlab', 2)
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Integer] id The ID of a user.
    # @return [Array<Gitlab::ObjectifiedHash>] Information about removed team member.
    def remove_team_member(project, id)
      delete("/projects/#{project}/members/#{id}")
    end

    # Gets a list of project hooks.
    #
    # @example
    #   Gitlab.project_hooks(42)
    #   Gitlab.project_hooks('gitlab')
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def project_hooks(project, options={})
      get("/projects/#{project}/hooks", :query => options)
    end

    # Gets a project hook.
    #
    # @example
    #   Gitlab.project_hook(42, 5)
    #   Gitlab.project_hook('gitlab', 5)
    #
    # @param  [Integer, String] project The ID or code name of a project.
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
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [String] url The hook URL.
    # @return [Gitlab::ObjectifiedHash] Information about added hook.
    def add_project_hook(project, url)
      post("/projects/#{project}/hooks", :body => {:url => url})
    end

    # Updates a project hook URL.
    #
    # @example
    #   Gitlab.edit_project_hook(42, 1, 'https://api.example.net/v1/webhooks/ci')
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Integer] id The ID of the hook.
    # @param  [String] url The hook URL.
    # @return [Gitlab::ObjectifiedHash] Information about updated hook.
    def edit_project_hook(project, id, url)
      put("/projects/#{project}/hooks/#{id}", :body => {:url => url})
    end

    # Deletes a hook from project.
    #
    # @example
    #   Gitlab.delete_project_hook('gitlab', 4)
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [String] id The ID of the hook.
    # @return [Gitlab::ObjectifiedHash] Information about deleted hook.
    def delete_project_hook(project, id)
      delete("/projects/#{project}/hooks/#{id}")
    end
  end
end
