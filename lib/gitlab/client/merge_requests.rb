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
  end
end
