# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to user snippets.
  # @see https://docs.gitlab.com/ce/api/snippets.html
  module UserSnippets
    # Get a list of the snippets of the current user.
    #
    # @example
    #   Gitlab::Client.user_snippets
    #
    # @return [Array<Gitlab::Client::ObjectifiedHash>] List of snippets of current user
    def user_snippets
      get('/snippets')
    end

    # Get a single snippet.
    #
    # @example
    #   Gitlab::Client.user_snippet(1)
    #
    # @param  [Integer] id ID of snippet to retrieve.
    # @return [Gitlab::Client::ObjectifiedHash] Information about the user snippet
    def user_snippet(id)
      get("/snippets/#{id}")
    end

    # Get raw contents of a single snippet.
    #
    # @example
    #   Gitlab::Client.user_snippet_raw(1)
    #
    # @param  [Integer] id ID of snippet to retrieve.
    # @return [String] User snippet text
    def user_snippet_raw(id)
      get("/snippets/#{id}/raw",
          format: nil,
          headers: { Accept: 'text/plain' },
          parser: ::Gitlab::Client::Parser)
    end

    # Create a new snippet.
    #
    # @example
    #   Gitlab::Client.create_user_snippet({ title: 'REST', file_name: 'api.rb', content: 'some code', description: 'Hello World snippet', visibility: 'public'})
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :title (required) Title of a snippet.
    # @option options [String] :file_name (required) Name of a snippet file.
    # @option options [String] :content (required) Content of a snippet.
    # @option options [String] :description (optional) Description of a snippet.
    # @option options [String] :visibility (optional) visibility of a snippet.
    # @return [Gitlab::Client::ObjectifiedHash] Information about created snippet.
    def create_user_snippet(options = {})
      post('/snippets', body: options)
    end

    # Update an existing snippet.
    #
    # @example
    #   Gitlab::Client.edit_user_snippet(34, { file_name: 'README.txt' })
    #   Gitlab::Client.edit_user_snippet(34, { file_name: 'README.txt', title: 'New title' })
    #
    # @param  [Integer] id ID of snippet to update.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :title (optional) Title of a snippet.
    # @option options [String] :file_name (optional) Name of a snippet file.
    # @option options [String] :content (optional) Content of a snippet.
    # @option options [String] :description (optional) Description of a snippet.
    # @option options [String] :visibility (optional) visibility of a snippet.
    # @return [Gitlab::Client::ObjectifiedHash] Information about updated snippet.
    def edit_user_snippet(id, options = {})
      put("/snippets/#{id}", body: options)
    end

    # Delete an existing snippet.
    #
    # @example
    #   Gitlab::Client.delete_user_snippet(14)
    #
    # @param  [Integer] id ID of snippet to delete.
    # @return [void] This API call returns an empty response body.
    def delete_user_snippet(id)
      delete("/snippets/#{id}")
    end

    # List all public snippets.
    #
    # @example
    #   Gitlab::Client.public_snippets
    #   Gitlab::Client.public_snippets(per_page: 2, page: 1)
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :per_page (optional) Number of snippets to return per page.
    # @option options [String] :page (optional) Page to retrieve.
    #
    # @return [Array<Gitlab::Client::ObjectifiedHash>] List of all public snippets
    def public_snippets(options = {})
      get('/snippets/public', query: options)
    end

    # Get user agent details for a snippet.
    #
    # @example
    #   Gitlab::Client.snippet_user_agent_details(1)
    #
    # @param  [Integer] id ID of snippet to delete.
    #
    # @return [Array<Gitlab::Client::ObjectifiedHash>] Details of the user agent
    def snippet_user_agent_details(id)
      get("/snippets/#{id}/user_agent_detail")
    end
  end
end
