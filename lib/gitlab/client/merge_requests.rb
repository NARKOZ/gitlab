class Gitlab::Client
  # Defines methods related to merge requests.
  module MergeRequests
    # Gets a list of project merge requests.
    #
    # @example
    #   Gitlab.merge_requests(5)
    #   Gitlab.merge_requests('gitlab', :per_page => 40)
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def merge_requests(project, options={})
      get("/projects/#{project}/merge_requests", :query => options)
    end

    # Gets a single merge request.
    #
    # @example
    #   Gitlab.merge_request(5, 36)
    #   Gitlab.merge_request('gitlab', 42)
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def merge_request(project, id)
      get("/projects/#{project}/merge_request/#{id}")
    end

    # Create a merge request.
    #
    # @example
    #   Gitlab.create_merge_request(5,
    #     :source_branch => 'feature_1',
    #     :target_branch => 'master',
    #     :title         => 'New feature.'
    #   )
    #   Gitlab.create_merge_request('gitlab',
    #     :source_branch => 'feature_1',
    #     :target_branch => 'master',
    #     :title         => 'New feature.',
    #     :assignee_id   => 1
    #   )
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Hash] containing attributes to post.
    # @return [Array<Gitlab::ObjectifiedHash>]
    #
    # Accepts source_branch, target_branch, assignee_id, & title in params.
    def create_merge_request(project, params={})

      raise("Attribute source_branch is required.") unless params.has_key?(:source_branch)
      raise("Attribute target_branch is required.") unless params.has_key?(:target_branch)
      raise("Attribute title is required.")         unless params.has_key?(:title)

      post("/projects/#{project}/merge_requests",
        :body => params
      )
    end

    # Update a merge request.
    #
    # @example
    #   Gitlab.update_merge_request(5, 3,
    #     :source_branch => 'feature_1',
    #     :target_branch => 'master',
    #     :title         => 'New feature.'
    #   )
    #   Gitlab.update_merge_request('gitlab', 3,
    #     :source_branch => 'feature_1',
    #     :target_branch => 'master',
    #     :title         => 'New feature.',
    #     :assignee_id   => 1
    #   )
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Hash] containing attributes to post.
    # @return [Array<Gitlab::ObjectifiedHash>]
    #
    # Accepts source_branch, target_branch, assignee_id, & title in params.
    def update_merge_request(project, merge_id, params={})
      put("/projects/#{project}/merge_request/#{merge_id}",
        :body => params
      )
    end

    # Comment on a merge request.
    #
    # @example
    #   Gitlab.comment_merge_request(5, 1, "Awesome merge!")
    #   Gitlab.comment_merge_request('gitlab', 1, "Awesome merge!")
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Hash] containing attributes to post.
    # @return [Array<Gitlab::ObjectifiedHash>]
    #
    # Accepts note (And alias, comment)
    def comment_merge_request(project, merge_id, params={})
      params[:note] = params[:comment]     if params.has_key?(:comment)
      raise("Attribute note is required.") unless params.has_key?(:note)

      post("/projects/#{project}/merge_request/#{merge_id}/comments",
        :body => params
      )
    end

  end
end
