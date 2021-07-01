# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to projects.
  # @see https://docs.gitlab.com/ce/api/projects.html
  module Projects
    # Gets a list of projects owned by the authenticated user.
    #
    # @example
    #   Gitlab.projects
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # (Any provided options will be passed to Gitlab. See {https://docs.gitlab.com/ce/api/projects.html#list-all-projects Gitlab docs} for all valid options)
    #
    # @return [Array<Gitlab::ObjectifiedHash>]
    def projects(options = {})
      get('/projects', query: options)
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
    def project_search(query, options = {})
      get('/projects', query: options.merge(search: query))
    end
    alias search_projects project_search

    # Gets information about a project.
    #
    # @example
    #   Gitlab.project(3)
    #   Gitlab.project('gitlab')
    #
    # @param  [Integer, String] id The ID or path of a project.
    # @param  options [string] :license Include project license data
    # @param  options [string] :statistics Include project statistics.
    # @param  options [string] :with_custom_attributes Include custom attributes in response. (admins only)
    # @return [Gitlab::ObjectifiedHash]
    def project(id, options = {})
      get("/projects/#{url_encode id}", query: options)
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
    # @option options [String] :path Repository name for new project. (Default is lowercase name with dashes)
    # @option options [String] :namespace_id The namespace in which to create a project.
    # @option options [Boolean] :wiki_enabled The wiki integration for a project (0 = false, 1 = true).
    # @option options [Boolean] :wall_enabled The wall functionality for a project (0 = false, 1 = true).
    # @option options [Boolean] :issues_enabled The issues integration for a project (0 = false, 1 = true).
    # @option options [Boolean] :snippets_enabled The snippets integration for a project (0 = false, 1 = true).
    # @option options [Boolean] :merge_requests_enabled The merge requests functionality for a project (0 = false, 1 = true).
    # @option options [String] :visibility The setting for making a project public ('private', 'internal', 'public').
    # @option options [Integer] :user_id The user/owner id of a project.
    # @return [Gitlab::ObjectifiedHash] Information about created project.
    def create_project(name, options = {})
      url = options[:user_id] ? "/projects/user/#{options[:user_id]}" : '/projects'
      post(url, body: { name: name }.merge(options))
    end

    # Deletes a project.
    #
    # @example
    #   Gitlab.delete_project(4)
    #
    # @param  [Integer, String] id The ID or path of a project.
    # @return [Gitlab::ObjectifiedHash] Information about deleted project.
    def delete_project(id)
      delete("/projects/#{url_encode id}")
    end

    # Gets a list of project team members.
    #
    # @example
    #   Gitlab.team_members(42)
    #   Gitlab.team_members('gitlab')
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :query The search query.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def team_members(project, options = {})
      get("/projects/#{url_encode project}/members", query: options)
    end

    # Gets a list of all project team members including inherited members.
    #
    # @example
    #   Gitlab.all_members(42)
    #   Gitlab.all_members('gitlab')
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :query The search query.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def all_members(project, options = {})
      get("/projects/#{url_encode project}/members/all", query: options)
    end

    # Gets a project team member.
    #
    # @example
    #   Gitlab.team_member('gitlab', 2)
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Integer] id The ID of a project team member.
    # @return [Gitlab::ObjectifiedHash]
    def team_member(project, id)
      get("/projects/#{url_encode project}/members/#{id}")
    end

    # Adds a user to project team.
    #
    # @example
    #   Gitlab.add_team_member('gitlab', 2, 40)
    #   Gitlab.add_team_member('gitlab', 2, 40, { expires_at: "2018-12-31"})
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Integer] id The ID of a user.
    # @param  [Integer] access_level The access level to project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :expires_at A date string in the format YEAR-MONTH-DAY.
    # @return [Gitlab::ObjectifiedHash] Information about added team member.
    def add_team_member(project, id, access_level, options = {})
      body = { user_id: id, access_level: access_level }.merge(options)
      post("/projects/#{url_encode project}/members", body: body)
    end

    # Updates a team member's project access level.
    #
    # @example
    #   Gitlab.edit_team_member('gitlab', 3, 20)
    #   Gitlab.edit_team_member('gitlab', 3, 20, { expires_at: "2018-12-31"})
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Integer] id The ID of a user.
    # @param  [Integer] access_level The access level to project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :expires_at A date string in the format YEAR-MONTH-DAY.
    # @return [Array<Gitlab::ObjectifiedHash>] Information about updated team member.
    def edit_team_member(project, id, access_level, options = {})
      body = { access_level: access_level }.merge(options)
      put("/projects/#{url_encode project}/members/#{id}", body: body)
    end

    # Removes a user from project team.
    #
    # @example
    #   Gitlab.remove_team_member('gitlab', 2)
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Integer] id The ID of a user.
    # @param  [Hash] options A customizable set of options.
    # @return [Gitlab::ObjectifiedHash] Information about removed team member.
    def remove_team_member(project, id)
      delete("/projects/#{url_encode project}/members/#{id}")
    end

    # Gets a list of project hooks.
    #
    # @example
    #   Gitlab.project_hooks(42)
    #   Gitlab.project_hooks('gitlab')
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def project_hooks(project, options = {})
      get("/projects/#{url_encode project}/hooks", query: options)
    end

    # Gets a project hook.
    #
    # @example
    #   Gitlab.project_hook(42, 5)
    #   Gitlab.project_hook('gitlab', 5)
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Integer] id The ID of a hook.
    # @return [Gitlab::ObjectifiedHash]
    def project_hook(project, id)
      get("/projects/#{url_encode project}/hooks/#{id}")
    end

    # Adds a new hook to the project.
    #
    # @example
    #   Gitlab.add_project_hook(42, 'https://api.example.net/v1/webhooks/ci')
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [String] url The hook URL.
    # @param  [Hash] options A customizable set of options.
    # @param  option [Boolean] :push_events Trigger hook on push events (0 = false, 1 = true)
    # @param  option [Boolean] :issues_events Trigger hook on issues events (0 = false, 1 = true)
    # @param  option [Boolean] :merge_requests_events Trigger hook on merge_requests events (0 = false, 1 = true)
    # @param  option [Boolean] :tag_push_events Trigger hook on push_tag events (0 = false, 1 = true)
    # @return [Gitlab::ObjectifiedHash] Information about added hook.
    def add_project_hook(project, url, options = {})
      body = { url: url }.merge(options)
      post("/projects/#{url_encode project}/hooks", body: body)
    end

    # Updates a project hook URL.
    #
    # @example
    #   Gitlab.edit_project_hook(42, 1, 'https://api.example.net/v1/webhooks/ci')
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Integer] id The ID of the hook.
    # @param  [String] url The hook URL.
    # @param  [Hash] options A customizable set of options.
    # @param  option [Boolean] :push_events Trigger hook on push events (0 = false, 1 = true)
    # @param  option [Boolean] :issues_events Trigger hook on issues events (0 = false, 1 = true)
    # @param  option [Boolean] :merge_requests_events Trigger hook on merge_requests events (0 = false, 1 = true)
    # @param  option [Boolean] :tag_push_events Trigger hook on push_tag events (0 = false, 1 = true)
    # @return [Gitlab::ObjectifiedHash] Information about updated hook.
    def edit_project_hook(project, id, url, options = {})
      body = { url: url }.merge(options)
      put("/projects/#{url_encode project}/hooks/#{id}", body: body)
    end

    # Deletes a hook from project.
    #
    # @example
    #   Gitlab.delete_project_hook('gitlab', 4)
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [String] id The ID of the hook.
    # @return [Gitlab::ObjectifiedHash] Information about deleted hook.
    def delete_project_hook(project, id)
      delete("/projects/#{url_encode project}/hooks/#{id}")
    end

    # Gets a project push rule.
    # @see https://docs.gitlab.com/ee/api/projects.html#show-project-push-rules
    #
    # @example
    #   Gitlab.push_rule(42)
    #
    # @param  [Integer] id The ID of a project.
    # @return [Gitlab::ObjectifiedHash]
    def push_rule(id)
      get("/projects/#{url_encode id}/push_rule")
    end

    # Adds a project push rule.
    # @see https://docs.gitlab.com/ee/api/projects.html#add-project-push-rule
    #
    # @example
    #   Gitlab.add_push_rule(42, { deny_delete_tag: false, commit_message_regex: '\\b[A-Z]{3}-[0-9]+\\b' })
    #
    # @param  [Integer] id The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @param  option [Boolean] :deny_delete_tag Do not allow users to remove git tags with git push (0 = false, 1 = true)
    # @param  option [String] :commit_message_regex Commit message regex
    # @return [Gitlab::ObjectifiedHash] Information about added push rule.
    def add_push_rule(id, options = {})
      post("/projects/#{url_encode id}/push_rule", body: options)
    end

    # Updates a project push rule.
    # @see https://docs.gitlab.com/ee/api/projects.html#edit-project-push-rule
    #
    # @example
    #   Gitlab.edit_push_rule(42, { deny_delete_tag: false, commit_message_regex: '\\b[A-Z]{3}-[0-9]+\\b' })
    #
    # @param  [Integer] id The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @param  option [Boolean] :deny_delete_tag Do not allow users to remove git tags with git push (0 = false, 1 = true)
    # @param  option [String] :commit_message_regex Commit message regex
    # @return [Gitlab::ObjectifiedHash] Information about updated push rule.
    def edit_push_rule(id, options = {})
      put("/projects/#{url_encode id}/push_rule", body: options)
    end

    # Deletes a push rule from a project.
    # @see https://docs.gitlab.com/ee/api/projects.html#delete-project-push-rule
    #
    # @example
    #   Gitlab.delete_push_rule(42)
    #
    # @param  [Integer] id The ID of a project.
    # @return [Gitlab::ObjectifiedHash] Information about deleted push rule.
    def delete_push_rule(id)
      delete("/projects/#{url_encode id}/push_rule")
    end

    # Mark this project as forked from the other
    #
    # @example
    #   Gitlab.make_forked(42, 24)
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Integer] id The ID of the project it is forked from.
    # @return [Gitlab::ObjectifiedHash] Information about the forked project.
    def make_forked_from(project, id)
      post("/projects/#{url_encode project}/fork/#{id}")
    end

    # Remove a forked_from relationship for a project.
    #
    # @example
    #  Gitlab.remove_forked(42)
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Integer] project The ID of the project it is forked from
    # @return [Gitlab::ObjectifiedHash] Information about the forked project.
    def remove_forked(project)
      delete("/projects/#{url_encode project}/fork")
    end

    # Gets a project deploy keys.
    #
    # @example
    #   Gitlab.deploy_keys(42)
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def deploy_keys(project, options = {})
      get("/projects/#{url_encode project}/deploy_keys", query: options)
    end

    # Gets a single project deploy key.
    #
    # @example
    #   Gitlab.deploy_key(42, 1)
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Integer] id The ID of a deploy key.
    # @return [Gitlab::ObjectifiedHash]
    def deploy_key(project, id)
      get("/projects/#{url_encode project}/deploy_keys/#{id}")
    end

    # Creates a new deploy key.
    #
    # @example
    #   Gitlab.create_deploy_key(42, 'My Key', 'Key contents', can_push: true)
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [String] title The title of a deploy key.
    # @param  [String] key The content of a deploy key.
    # @param  [Hash] options A customizable set of options.
    # @return [Gitlab::ObjectifiedHash] Information about created deploy key.
    def create_deploy_key(project, title, key, options = {})
      post("/projects/#{url_encode project}/deploy_keys", body: { title: title, key: key }.merge(options))
    end

    # Enables a deploy key at the project.
    #
    # @example
    #   Gitlab.enable_deploy_key(42, 66)
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Integer] key The ID of a deploy key.
    # @return [Gitlab::ObjectifiedHash] Information about the enabled deploy key.
    def enable_deploy_key(project, key)
      post("/projects/#{url_encode project}/deploy_keys/#{key}/enable", body: { id: project, key_id: key })
    end

    # Disables a deploy key at the project.
    #
    # @example
    #   Gitlab.disable_deploy_key(42, 66)
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Integer] key The ID of a deploy key.
    # @return [Gitlab::ObjectifiedHash] Information about the disabled deploy key.
    def disable_deploy_key(project, key)
      post("/projects/#{url_encode project}/deploy_keys/#{key}/disable", body: { id: project, key_id: key })
    end

    # Updates an existing deploy key.
    #
    # @example
    #   Gitlab.edit_deploy_key(42, 66, 'New key name', can_push: false)
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Integer] id The ID of a deploy key.
    # @param  [String] title The title of a deploy key.
    # @param  [Hash] options A customizable set of options.
    # @return [Gitlab::ObjectifiedHash] Information about created deploy key.
    def edit_deploy_key(project, id, title, options = {})
      put("/projects/#{url_encode project}/deploy_keys/#{id}", body: { title: title }.merge(options))
    end

    # Deletes a deploy key from project.
    #
    # @example
    #   Gitlab.delete_deploy_key(42, 1)
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Integer] id The ID of a deploy key.
    # @return [Gitlab::ObjectifiedHash] Information about deleted deploy key.
    def delete_deploy_key(project, id)
      delete("/projects/#{url_encode project}/deploy_keys/#{id}")
    end

    # Forks a project into the user namespace.
    #
    # @example
    #   Gitlab.create_fork(42)
    #   Gitlab.create_fork(42, { sudo: 'another_username' })
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :sudo The username the project will be forked for
    # @return [Gitlab::ObjectifiedHash] Information about the forked project.
    def create_fork(id, options = {})
      post("/projects/#{url_encode id}/fork", body: options)
    end

    # Get a list of all visible projects across GitLab for the authenticated user.
    # When accessed without authentication, only public projects are returned.
    #
    # Note: This feature was introduced in GitLab 10.1
    #
    # @example
    #   Gitlab.project_forks(42)
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @option options [String] :order_by Return requests ordered by id, name, created_at or last_activity_at fields
    # @option options [String] :sort Return requests sorted in asc or desc order
    # @return [Array<Gitlab::ObjectifiedHash>]
    def project_forks(id, options = {})
      get("/projects/#{url_encode id}/forks", query: options)
    end

    # Updates an existing project.
    #
    # @example
    #   Gitlab.edit_project(42)
    #   Gitlab.edit_project(42, { name: 'Project Name' })
    #   Gitlab.edit_project('project-name', { name: 'New Project Name', path: 'new-project-patth' })
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Hash] options A customizable set of options
    # @option options [String] :name The name of a project
    # @option options [String] :path The project's repository name, also used in Gitlab's URLs
    # @option options [String] :description The description to show in Gitlab
    # (Any provided options will be passed to Gitlab. See {https://docs.gitlab.com/ce/api/projects.html#edit-project Gitlab docs} for all valid options)
    #
    # @return [Gitlab::ObjectifiedHash] Information about the edited project.
    def edit_project(id, options = {})
      put("/projects/#{url_encode id}", body: options)
    end

    # Share project with group.
    #
    # @example
    #   Gitlab.share_project_with_group('gitlab', 2, 40)
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Integer] id The ID of a group.
    # @param  [Integer] group_access The access level to project.
    def share_project_with_group(project, id, group_access)
      post("/projects/#{url_encode project}/share", body: { group_id: id, group_access: group_access })
    end

    # Unshare project with group.
    #
    # @example
    #   Gitlab.unshare_project_with_group('gitlab', 2)
    #
    # @param  [Integer, String] project The ID or path of a project.
    # @param  [Integer] id The ID of a group.
    # @return [void] This API call returns an empty response body.
    def unshare_project_with_group(project, id)
      delete("/projects/#{url_encode project}/share/#{id}")
    end

    # Transfer a project to a new namespace.
    #
    # @example
    #   Gitlab.transfer_project(42, 'yolo')
    #
    # @param  [Integer, String] project The ID or path of a project
    # @param  [Integer, String] namespace The ID or path of the namespace to transfer to project to
    # @return [Gitlab::ObjectifiedHash] Information about transfered project.
    def transfer_project(project, namespace)
      put("/projects/#{url_encode project}/transfer", body: { namespace: namespace })
    end

    # Stars a project.
    # @see https://docs.gitlab.com/ce/api/projects.html#star-a-project
    #
    # @example
    #   Gitlab.star_project(42)
    #   Gitlab.star_project('gitlab-org/gitlab-ce')
    #
    # @param  [Integer, String] id The ID or path of a project.
    # @return [Gitlab::ObjectifiedHash] Information about starred project.
    def star_project(id)
      post("/projects/#{url_encode id}/star")
    end

    # Unstars a project.
    # @see https://docs.gitlab.com/ce/api/projects.html#unstar-a-project
    #
    # @example
    #   Gitlab.unstar_project(42)
    #   Gitlab.unstar_project('gitlab-org/gitlab-ce')
    #
    # @param  [Integer, String] id The ID or path of a project.
    # @return [Gitlab::ObjectifiedHash] Information about unstarred project.
    def unstar_project(id)
      delete("/projects/#{url_encode id}/star")
    end

    # Get a list of visible projects that the given user has starred.
    # @see https://docs.gitlab.com/ee/api/projects.html#list-projects-starred-by-a-user
    #
    # @example
    #   Gitlab.user_starred_projects(1)
    #   Gitlab.user_starred_projects(1, { order_by: 'last_activity_at' })
    #   Gitlab.user_starred_projects('username', { order_by: 'name', sort: 'asc' })
    #
    # @param  [Integer, String] user_id The ID or username of the user.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :per_page Number of projects to return per page
    # @option options [String] :page The page to retrieve
    # @option options [String] :order_by Return projects ordered by id, name, path, created_at, updated_at, or last_activity_at fields.
    # @option options [String] :sort Return projects sorted in asc or desc order.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def user_starred_projects(user_id, options = {})
      get("/users/#{url_encode user_id}/starred_projects", query: options)
    end

    # Get a list of visible projects for the given user.
    # @see https://docs.gitlab.com/ee/api/projects.html#list-user-projects
    #
    # @example
    #   Gitlab.user_projects(1)
    #   Gitlab.user_projects(1, { order_by: 'last_activity_at' })
    #   Gitlab.user_projects('username', { order_by: 'name', sort: 'asc' })
    #
    # @param  [Integer, String] user_id The ID or username of the user.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :per_page Number of projects to return per page
    # @option options [String] :page The page to retrieve
    # @option options [String] :order_by Return projects ordered by id, name, path, created_at, updated_at, or last_activity_at fields.
    # @option options [String] :sort Return projects sorted in asc or desc order.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def user_projects(user_id, options = {})
      get("/users/#{url_encode user_id}/projects", query: options)
    end

    # Uploads a file to the specified project to be used in an issue or
    # merge request description, or a comment.
    # @see https://docs.gitlab.com/ee/api/projects.html#upload-a-file
    #
    # @example
    #   Gitlab.upload_file(1, '/full/path/to/avatar.jpg')
    #
    # @param  [Integer, String] id The ID or path of a project.
    # @param  [String] file_fullpath The fullpath of the file you are interested to upload.
    # @return [Gitlab::ObjectifiedHash]
    def upload_file(id, file_fullpath)
      post("/projects/#{url_encode id}/uploads", body: { file: File.open(file_fullpath, 'r') })
    end

    # Get all project templates of a particular type
    # @see https://docs.gitlab.com/ce/api/project_templates.html
    #
    # @example
    #   Gitlab.project_templates(1, 'dockerfiles')
    #   Gitlab.project_templates(1, 'licenses')
    #
    # @param  [Integer, String] id The ID or URL-encoded path of the project.
    # @param  [String] type The type (dockerfiles|gitignores|gitlab_ci_ymls|licenses) of the template
    # @return [Array<Gitlab::ObjectifiedHash>]
    def project_templates(project, type)
      get("/projects/#{url_encode project}/templates/#{type}")
    end

    # Get one project template of a particular type
    # @see https://docs.gitlab.com/ce/api/project_templates.html
    #
    # @example
    #   Gitlab.project_template(1, 'dockerfiles', 'dockey')
    #   Gitlab.project_template(1, 'licenses', 'gpl', { project: 'some project', fullname: 'Holder Holding' })
    #
    # @param  [Integer, String] project The ID or URL-encoded path of the project.
    # @param  [String] type The type (dockerfiles|gitignores|gitlab_ci_ymls|licenses) of the template
    # @param  [String] key The key of the template, as obtained from the collection endpoint
    # @param  [Hash] options A customizable set of options.
    # @option options [String] project(optional) The project name to use when expanding placeholders in the template. Only affects licenses
    # @option options [String] fullname(optional) The full name of the copyright holder to use when expanding placeholders in the template. Only affects licenses
    # @return [Gitlab::ObjectifiedHash]
    def project_template(project, type, key, options = {})
      get("/projects/#{url_encode project}/templates/#{type}/#{key}", query: options)
    end

    # Archives a project.
    #
    # @example
    #   Gitlab.archive_project(4)
    #
    # @param  [Integer, String] id The ID or path of a project.
    # @return [Gitlab::ObjectifiedHash] Information about archived project.
    def archive_project(id)
      post("/projects/#{url_encode id}/archive")
    end

    # Unarchives a project.
    #
    # @example
    #   Gitlab.unarchive_project(4)
    #
    # @param  [Integer, String] id The ID or path of a project.
    # @return [Gitlab::ObjectifiedHash] Information about unarchived project.
    def unarchive_project(id)
      post("/projects/#{url_encode id}/unarchive")
    end

    # Gets project custom_attributes.
    #
    # @example
    #   Gitlab.project_custom_attributes(2)
    #
    # @param  [Integer] project_id The ID of a project.
    # @return [Gitlab::ObjectifiedHash]
    def project_custom_attributes(project_id)
      get("/projects/#{project_id}/custom_attributes")
    end

    # Gets single project custom_attribute.
    #
    # @example
    #   Gitlab.project_custom_attribute(key, 2)
    #
    # @param  [String] key The custom_attributes key
    # @param  [Integer] project_id The ID of a project.
    # @return [Gitlab::ObjectifiedHash]
    def project_custom_attribute(key, project_id)
      get("/projects/#{project_id}/custom_attributes/#{key}")
    end

    # Creates a new custom_attribute
    #
    # @example
    #   Gitlab.add_custom_attribute('some_new_key', 'some_new_value', 2)
    #
    # @param  [String] key The custom_attributes key
    # @param  [String] value The custom_attributes value
    # @param  [Integer] project_id The ID of a project.
    # @return [Gitlab::ObjectifiedHash]
    def add_project_custom_attribute(key, value, project_id)
      url = "/projects/#{project_id}/custom_attributes/#{key}"
      put(url, body: { value: value })
    end

    # Delete custom_attribute
    # Will delete a custom_attribute
    #
    # @example
    #   Gitlab.delete_project_custom_attribute('somekey', 2)
    #
    # @param  [String] key The custom_attribute key to delete
    # @param  [Integer] project_id The ID of a project.
    # @return [Boolean]
    def delete_project_custom_attribute(key, project_id = nil)
      delete("/projects/#{project_id}/custom_attributes/#{key}")
    end

    # List project deploy tokens
    #
    # @example
    #   Gitlab.project_deploy_tokens(42)
    #
    # @param [Integer, String] id The ID or path of a project.
    # @option options [Boolean] :active Limit by active status. Optional.
    def project_deploy_tokens(project, options = {})
      get("/projects/#{url_encode project}/deploy_tokens", query: options)
    end
  end
end
