class Gitlab::Client
  # Defines methods related to snippets.
  module Snippets
    # Gets a list of project's snippets.
    #
    # @example
    #   Gitlab.snippets(42)
    #   Gitlab.snippets('gitlab')
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Gitlab::ObjectifiedHash]
    def snippets(project, options={})
      get("/projects/#{project}/snippets", :query => options)
    end

    # Gets information about a snippet.
    #
    # @example
    #   Gitlab.snippet(2, 14)
    #   Gitlab.snippet('gitlab', 34)
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Integer] id The ID of a snippet.
    # @return [Gitlab::ObjectifiedHash]
    def snippet(project, id)
      get("/projects/#{project}/snippets/#{id}")
    end

    # Creates a new snippet.
    #
    # @example
    #   Gitlab.create_snippet('gitlab',
    #     {:title => 'REST', :file_name => 'api.rb', :code => 'some code'})
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :title The title of a snippet.
    # @option options [String] :file_name The name of a snippet file.
    # @option options [String] :code The content of a snippet.
    # @option options [String] :lifetime The expiration date of a snippet.
    # @return [Gitlab::ObjectifiedHash] Information about created snippet.
    def create_snippet(project, options={})
      post("/projects/#{project}/snippets", :body => options)
    end

    # Updates a snippet.
    #
    # @example
    #   Gitlab.edit_snippet('gitlab', 34, :file_name => 'README.txt')
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Integer] id The ID of a snippet.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :title The title of a snippet.
    # @option options [String] :file_name The name of a snippet file.
    # @option options [String] :code The content of a snippet.
    # @option options [String] :lifetime The expiration date of a snippet.
    # @return [Gitlab::ObjectifiedHash] Information about updated snippet.
    def edit_snippet(project, id, options={})
      put("/projects/#{project}/snippets/#{id}", :body => options)
    end

    # Deletes a snippet.
    #
    # @example
    #   Gitlab.delete_snippet(2, 14)
    #   Gitlab.delete_snippet('gitlab', 34)
    #
    # @param  [Integer, String] project The ID or code name of a project.
    # @param  [Integer] id The ID of a snippet.
    # @return [Gitlab::ObjectifiedHash] Information about deleted snippet.
    def delete_snippet(project, id)
      delete("/projects/#{project}/snippets/#{id}")
    end
  end
end
