# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to repositories.
  # @see https://docs.gitlab.com/ce/api/repositories.html
  module Repositories
    # Get file tree project (root level).
    #
    # @example
    #   Gitlab.tree(42)
    #   Gitlab.tree(42, { path: 'Gemfile' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :path The path inside repository.
    # @option options [String] :ref The name of a repository branch or tag.
    # @option options [Integer] :per_page Number of results to show per page (default = 20)
    # @return [Gitlab::ObjectifiedHash]
    def tree(project, options = {})
      get("/projects/#{url_encode project}/repository/tree", query: options)
    end
    alias repo_tree tree

    # Get project repository archive
    #
    # @example
    #   Gitlab.repo_archive(42)
    #   Gitlab.repo_archive(42, 'deadbeef')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] ref The commit sha, branch, or tag to download.
    # @param  [String] format The archive format. Options are: tar.gz (default), tar.bz2, tbz, tbz2, tb2, bz2, tar, and zip
    # @return [Gitlab::FileResponse]
    def repo_archive(project, ref = 'master', format = 'tar.gz')
      get("/projects/#{url_encode project}/repository/archive.#{format}",
          format: nil,
          headers: { Accept: 'application/octet-stream' },
          query: { sha: ref },
          parser: proc { |body, _|
            if body.encoding == Encoding::ASCII_8BIT # binary response
              ::Gitlab::FileResponse.new StringIO.new(body, 'rb+')
            else # error with json response
              ::Gitlab::Request.parse(body)
            end
          })
    end

    # Compares branches, tags or commits.
    #
    # @example
    #   Gitlab.compare(42, 'master', 'feature/branch')
    #   Gitlab.repo_compare(42, 'master', 'feature/branch')
    #
    # @param [Integer] project The ID of a project.
    # @param [String] from The commit SHA or branch name of from branch.
    # @param [String] to The commit SHA or branch name of to branch.
    # @return [Gitlab::ObjectifiedHash]
    def compare(project, from, to)
      get("/projects/#{url_encode project}/repository/compare", query: { from: from, to: to })
    end
    alias repo_compare compare

    # Get the common ancestor for 2 refs (commit SHAs, branch names or tags).
    #
    # @example
    #   Gitlab.merge_base(42, ['master', 'feature/branch'])
    #   Gitlab.merge_base(42, ['master', 'feature/branch'])
    #
    # @param [Integer, String] project The ID or URL-encoded path of the project.
    # @param [Array] refs Array containing 2 commit SHAs, branch names, or tags.
    # @return [Gitlab::ObjectifiedHash]
    def merge_base(project, refs)
      get("/projects/#{url_encode project}/repository/merge_base", query: { refs: refs })
    end

    # Get project repository contributors.
    #
    # @example
    #   Gitlab.contributors(42)
    #   Gitlab.contributors(42, { order: 'name' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :order_by Order by name, email or commits (default = commits).
    # @option options [String] :sort Sort order asc or desc (default = asc).
    # @return [Array<Gitlab::ObjectifiedHash>]
    def contributors(project, options = {})
      get("/projects/#{url_encode project}/repository/contributors", query: options)
    end
    alias repo_contributors contributors

    # Generate changelog data
    #
    # @example
    #   Gitlab.generate_changelog(42, 'v1.0.0')
    #   Gitlab.generate_changelog(42, 'v1.0.0', branch: 'main')
    #
    # @param [Integer, String] project The ID or name of a project
    # @param [String] version The version to generate the changelog for
    # @param [Hash] options A customizable set of options
    # @option options [String] :from The start of the range of commits (SHA)
    # @option options [String] :to The end of the range of commits (as a SHA) to use for the changelog
    # @option options [String] :date The date and time of the release, defaults to the current time
    # @option options [String] :branch The branch to commit the changelog changes to
    # @option options [String] :trailer The Git trailer to use for including commits
    # @option options [String] :file The file to commit the changes to
    # @option options [String] :message The commit message to produce when committing the changes
    # @return [bool]
    def generate_changelog(project, version, options = {})
      post("/projects/#{url_encode project}/repository/changelog", body: options.merge(version: version))
    end

    # Get changelog data
    #
    # @example
    #   Gitlab.get_changelog(42, 'v1.0.0')
    #
    # @param [Integer, String] project The ID or name of a project
    # @param [String] version The version to generate the changelog for
    # @param [Hash] options A customizable set of options
    # @option options [String] :from The start of the range of commits (SHA)
    # @option options [String] :to The end of the range of commits (as a SHA) to use for the changelog
    # @option options [String] :date The date and time of the release, defaults to the current time
    # @option options [String] :trailer The Git trailer to use for including commits
    # @return [Gitlab::ObjectifiedHash]
    def get_changelog(project, version, options = {})
      get("/projects/#{url_encode project}/repository/changelog", body: options.merge(version: version))
    end
  end
end
