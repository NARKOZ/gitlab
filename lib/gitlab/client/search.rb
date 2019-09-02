# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to global searches, searching in projects and searching in groups.
  # @see https://docs.gitlab.com/ce/api/search.html
  module Search
    # Search globally across the GitLab instance.
    #
    # @example
    #   Gitlab.search_globally('projects', 'gitlab')
    #   Gitlab.search_globally('issues', 'gitlab')
    #   Gitlab.search_globally('merge_requests', 'gitlab')
    #   Gitlab.search_globally('milestones', 'gitlab')
    #   Gitlab.search_globally('snippet_titles', 'gitlab')
    #   Gitlab.search_globally('snippet_blobs', 'gitlab')
    #
    # @param  [String] scope The scope to search in. Currently these scopes are supported: projects, issues, merge_requests, milestones, snippet_titles, snippet_blobs.
    # @param  [String] search The search query.
    # @return [Array<Gitlab::ObjectifiedHash>] Returns a list of responses depending on the requested scope.
    def search_globally(scope, search)
      options = { scope: scope, search: search }
      get('/search', query: options)
    end

    # Search within the specified group.
    #
    # @example
    #   Gitlab.search_in_group(1, 'projects', 'gitlab')
    #   Gitlab.search_in_group(1, 'issues', 'gitlab')
    #   Gitlab.search_in_group(1, 'merge_requests', 'gitlab')
    #   Gitlab.search_in_group(1, 'milestones', 'gitlab')
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [String] scope The scope to search in. Currently these scopes are supported: projects, issues, merge_requests, milestones.
    # @param  [String] search The search query.
    # @return [Array<Gitlab::ObjectifiedHash>] Returns a list of responses depending on the requested scope.
    def search_in_group(group, scope, search)
      options = { scope: scope, search: search }
      get("/groups/#{url_encode group}/search", query: options)
    end

    # Search within the specified project.
    #
    # @example
    #   Gitlab.search_in_project(1, 'issues', 'gitlab')
    #   Gitlab.search_in_project(1, 'merge_requests', 'gitlab')
    #   Gitlab.search_in_project(1, 'milestones', 'gitlab')
    #   Gitlab.search_in_project(1, 'notes', 'gitlab')
    #   Gitlab.search_in_project(1, 'wiki_blobs', 'gitlab')
    #   Gitlab.search_in_project(1, 'commits', 'gitlab')
    #   Gitlab.search_in_project(1, 'blobs', 'gitlab')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] scope The scope to search in. Currently these scopes are supported: issues, merge_requests, milestones, notes, wiki_blobs, commits, blobs.
    # @param  [String] search The search query.
    # @return [Array<Gitlab::ObjectifiedHash>] Returns a list of responses depending on the requested scope.
    def search_in_project(project, scope, search, ref = nil)
      options = { scope: scope, search: search }

      # Add ref filter if provided - backward compatible with main project
      options[:ref] = ref unless ref.nil?

      get("/projects/#{url_encode project}/search", query: options)
    end
  end
end
