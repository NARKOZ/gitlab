# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to snippets.
  # @see https://docs.gitlab.com/ce/api/project_snippets.html
  module Snippets
    # Gets a list of project's snippets.
    #
    # @example
    #   Gitlab.snippets(42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Gitlab::ObjectifiedHash]
    def snippets(project, options = {})
      get("/projects/#{url_encode project}/snippets", query: options)
    end

    # Gets information about a snippet.
    #
    # @example
    #   Gitlab.snippet(2, 14)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a snippet.
    # @return [Gitlab::ObjectifiedHash]
    def snippet(project, id)
      get("/projects/#{url_encode project}/snippets/#{id}")
    end

    # Creates a new snippet.
    #
    # @example
    #   Gitlab.create_snippet(42, { title: 'REST', file_name: 'api.rb', code: 'some code', visibility: 'public'})
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :title (required) The title of a snippet.
    # @option options [String] :file_name (required) The name of a snippet file.
    # @option options [String] :code (required) The content of a snippet.
    # @option options [String] :lifetime (optional) The expiration date of a snippet.
    # @option options [String] :visibility (required) The visibility of a snippet
    # @return [Gitlab::ObjectifiedHash] Information about created snippet.
    def create_snippet(project, options = {})
      post("/projects/#{url_encode project}/snippets", body: options)
    end

    # Updates a snippet.
    #
    # @example
    #   Gitlab.edit_snippet(42, 34, { file_name: 'README.txt' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a snippet.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :title The title of a snippet.
    # @option options [String] :file_name The name of a snippet file.
    # @option options [String] :code The content of a snippet.
    # @option options [String] :lifetime The expiration date of a snippet.
    # @option options [String] :visibility (optional) The visibility of a snippet
    # @return [Gitlab::ObjectifiedHash] Information about updated snippet.
    def edit_snippet(project, id, options = {})
      put("/projects/#{url_encode project}/snippets/#{id}", body: options)
    end

    # Deletes a snippet.
    #
    # @example
    #   Gitlab.delete_snippet(2, 14)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a snippet.
    # @return [Gitlab::ObjectifiedHash] Information about deleted snippet.
    def delete_snippet(project, id)
      delete("/projects/#{url_encode project}/snippets/#{id}")
    end

    # Returns raw project snippet content as plain text.
    #
    # @example
    #   Gitlab.snippet_content(2, 14)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a snippet.
    # @return [Gitlab::ObjectifiedHash] Information about deleted snippet.
    def snippet_content(project, id)
      get("/projects/#{url_encode project}/snippets/#{id}/raw",
          format: nil,
          headers: { Accept: 'text/plain' },
          parser: ::Gitlab::Request::Parser)
    end
  end
end
