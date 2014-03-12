class Gitlab::Client
  # Defines methods related to repositories.
  module Repositories
    # Gets a list of project repository tags.
    #
    # @example
    #   Gitlab.tags(42)
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def tags(project, options={})
      get("/projects/#{project}/repository/tags", :query => options)
    end
    alias_method :repo_tags, :tags

    # Gets a list of project repositiory branches.
    #
    # @example
    #   Gitlab.branches(42)
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def branches(project, options={})
      get("/projects/#{project}/repository/branches", :query => options)
    end
    alias_method :repo_branches, :branches

    # Gets information about a repository branch.
    #
    # @example
    #   Gitlab.branch(3, 'api')
    #   Gitlab.repo_branch(5, 'master')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] branch The name of the branch.
    # @return [Gitlab::ObjectifiedHash]
    def branch(project, branch)
      get("/projects/#{project}/repository/branches/#{branch}")
    end
    alias_method :repo_branch, :branch

    # Gets a list of project commits.
    #
    # @example
    #   Gitlab.commits('viking')
    #   Gitlab.repo_commits('gitlab', :ref_name => 'api')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :ref_name The branch or tag name of a project repository.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def commits(project, options={})
      get("/projects/#{project}/repository/commits", :query => options)
    end
    alias_method :repo_commits, :commits

    # Fetches the content of a specific file
    #
    # @example
    #   Gitlab.files(3, 'README.md')
    #   Gitlab.files(3, 'README.md', 'e38dc1')
    #   Gitlab.repo_files(5, 'README.md', 'v1.0.0')
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] file_path The path of the file, relative to the root of the project.
    # @param  [String] ref The reference to the file. A SHA, tag, or branch name.
    # @return [String] The contents of the file.
    def files(project, file_path, ref='master')
      get("/projects/#{project}/repository/files", :query => { file_path: file_path, ref: ref })
    end
    alias_method :repo_files, :files

  end
end
