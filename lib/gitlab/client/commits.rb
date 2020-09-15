# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to repository commits.
  # @see https://docs.gitlab.com/ce/api/commits.html
  module Commits
    # Gets a list of project commits.
    #
    # @example
    #   Gitlab.commits('viking')
    #   Gitlab.repo_commits('gitlab', { ref: 'api' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :ref The branch or tag name of a project repository.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def commits(project, options = {})
      get("/projects/#{url_encode project}/repository/commits", query: options)
    end
    alias repo_commits commits

    # Gets a specific commit identified by the commit hash or name of a branch or tag.
    #
    # @example
    #   Gitlab.commit(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    #   Gitlab.repo_commit(3, 'ed899a2f4b50b4370feeea94676502b42383c746')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] sha The commit hash or name of a repository branch or tag
    # @return [Gitlab::ObjectifiedHash]
    def commit(project, sha)
      get("/projects/#{url_encode project}/repository/commits/#{sha}")
    end
    alias repo_commit commit

    # Get all references (from branches or tags) a commit is pushed to.
    #
    # @example
    #   Gitlab.commit_refs(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] sha The commit hash
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :type The scope of commits. Possible values `branch`, `tag`, `all`. Default is `all`.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Gitlab::ObjectifiedHash]
    def commit_refs(project, sha, options = {})
      get("/projects/#{url_encode project}/repository/commits/#{sha}/refs", query: options)
    end

    # Cherry picks a commit to a given branch.
    #
    # @example
    #   Gitlab.cherry_pick_commit(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6', 'master')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] sha The commit hash or name of a repository branch or tag
    # @param  [String] branch The name of the branch
    # @param  [Hash] options A customizable set of options.
    # @option options [Boolean] :dry_run Don't commit any changes
    # @return [Gitlab::ObjectifiedHash]
    def cherry_pick_commit(project, sha, branch, options = {})
      options[:branch] = branch

      post("/projects/#{url_encode project}/repository/commits/#{sha}/cherry_pick", body: options)
    end

    # Reverts a commit in a given branch.
    #
    # @example
    #   Gitlab.revert_commit(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6', 'master')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] sha The commit hash or name of a repository branch or tag
    # @param  [String] branch The name of the branch
    # @param  [Hash] options A customizable set of options.
    # @option options [Boolean] :dry_run Don't commit any changes
    # @return [Gitlab::ObjectifiedHash]
    def revert_commit(project, sha, branch, options = {})
      options[:branch] = branch

      post("/projects/#{url_encode project}/repository/commits/#{sha}/revert", body: options)
    end

    # Get the diff of a commit in a project.
    #
    # @example
    #   Gitlab.commit_diff(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    #   Gitlab.repo_commit_diff(3, 'ed899a2f4b50b4370feeea94676502b42383c746')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] sha The name of a repository branch or tag or if not given the default branch.
    # @return [Gitlab::ObjectifiedHash]
    def commit_diff(project, sha)
      get("/projects/#{url_encode project}/repository/commits/#{sha}/diff")
    end
    alias repo_commit_diff commit_diff

    # Gets a list of comments for a commit.
    #
    # @example
    #   Gitlab.commit_comments(5, 'c9f9662a9b1116c838b523ed64c6abdb4aae4b8b')
    #
    # @param [Integer] project The ID of a project.
    # @param [String] sha The commit hash or name of a repository branch or tag.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def commit_comments(project, commit, options = {})
      get("/projects/#{url_encode project}/repository/commits/#{commit}/comments", query: options)
    end
    alias repo_commit_comments commit_comments

    # Creates a new comment for a commit.
    #
    # @example
    #   Gitlab.create_commit_comment(5, 'c9f9662a9b1116c838b523ed64c6abdb4aae4b8b', 'Nice work on this commit!')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] sha The commit hash or name of a repository branch or tag.
    # @param  [String] note The text of a comment.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :path The file path.
    # @option options [Integer] :line The line number.
    # @option options [String] :line_type The line type (new or old).
    # @return [Gitlab::ObjectifiedHash] Information about created comment.
    def create_commit_comment(project, commit, note, options = {})
      post("/projects/#{url_encode project}/repository/commits/#{commit}/comments", body: options.merge(note: note))
    end
    alias repo_create_commit_comment create_commit_comment

    # Get the status of a commit
    #
    # @example
    #   Gitlab.commit_status(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    #   Gitlab.commit_status(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6', { name: 'jenkins' })
    #   Gitlab.commit_status(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6', { name: 'jenkins', all: true })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] sha The commit hash
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :ref Filter by ref name, it can be branch or tag
    # @option options [String] :stage Filter by stage
    # @option options [String] :name Filter by status name, eg. jenkins
    # @option options [Boolean] :all The flag to return all statuses, not only latest ones
    def commit_status(project, sha, options = {})
      get("/projects/#{url_encode project}/repository/commits/#{sha}/statuses", query: options)
    end
    alias repo_commit_status commit_status

    # Adds or updates a status of a commit.
    #
    # @example
    #   Gitlab.update_commit_status(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6', 'success')
    #   Gitlab.update_commit_status(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6', 'failed', { name: 'jenkins' })
    #   Gitlab.update_commit_status(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6', 'canceled', { name: 'jenkins', target_url: 'http://example.com/builds/1' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] sha The commit hash
    # @param  [String] state of the status. Can be: pending, running, success, failed, canceled
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :ref The ref (branch or tag) to which the status refers
    # @option options [String] :name Filter by status name, eg. jenkins
    # @option options [String] :target_url The target URL to associate with this status
    def update_commit_status(project, sha, state, options = {})
      post("/projects/#{url_encode project}/statuses/#{sha}", body: options.merge(state: state))
    end
    alias repo_update_commit_status update_commit_status

    # Creates a single commit with one or more changes
    #
    # @see https://docs.gitlab.com/ce/api/commits.html#create-a-commit-with-multiple-files-and-actions
    # Introduced in Gitlab 8.13
    #
    # @example
    # Gitlab.create_commit(2726132, 'master', 'refactors everything', [{action: 'create', file_path: '/foo.txt', content: 'bar'}])
    # Gitlab.create_commit(2726132, 'master', 'refactors everything', [{action: 'delete', file_path: '/foo.txt'}])
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param [String] branch the branch name you wish to commit to
    # @param [String] message the commit message
    # @param [Array[Hash]] An array of action hashes to commit as a batch. See the next table for what attributes it can take.
    # @option options [String] :author_email the email address of the author
    # @option options [String] :author_name the name of the author
    # @return [Gitlab::ObjectifiedHash] hash of commit related data
    def create_commit(project, branch, message, actions, options = {})
      payload = {
        branch: branch,
        commit_message: message,
        actions: actions
      }.merge(options)
      post("/projects/#{url_encode project}/repository/commits", body: payload)
    end

    # Gets a list of merge requests for a commit.
    #
    # @see https://docs.gitlab.com/ce/api/commits.html#list-merge-requests-associated-with-a-commit
    # Introduced in Gitlab 10.7
    #
    # @example
    #   Gitlab.commit_merge_requests(5, 'c9f9662a9b1116c838b523ed64c6abdb4aae4b8b')
    #
    # @param [Integer] project The ID of a project.
    # @param [String] sha The commit hash.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def commit_merge_requests(project, commit, options = {})
      get("/projects/#{url_encode project}/repository/commits/#{commit}/merge_requests", query: options)
    end
    alias repo_commit_merge_requests commit_merge_requests
  end
end
