# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to wikis.
  # @see https://docs.gitlab.com/ce/api/wikis.html
  module Wikis
    # Get all wiki pages for a given project.
    #
    # @example
    #   Gitlab.wikis(3)
    #   Gitlab.wikis(3, {with_content: 'Some wiki content'})
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] with_content(optional) Include pages content
    # @return [Array<Gitlab::ObjectifiedHash>]
    def wikis(project, options = {})
      get("/projects/#{url_encode project}/wikis", query: options)
    end

    # Get a wiki page for a given project.
    #
    # @example
    #   Gitlab.wiki(3, 'home')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] slug The slug (a unique string) of the wiki page
    # @return [Gitlab::ObjectifiedHash]
    def wiki(project, slug)
      get("/projects/#{url_encode project}/wikis/#{slug}")
    end

    # Creates a new wiki page for the given repository with the given title, slug, and content.
    #
    # @example
    #   Gitlab.create_wiki(3, 'Some Title', 'Some Content')
    #   Gitlab.create_wiki(3, 'Some Title', 'Some Content', { format: 'rdoc' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] content The content of the wiki page.
    # @param  [String] title The title of the wiki page.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] format (optional) The format of the wiki page. Available formats are: markdown (default), rdoc, and asciidoc.
    # @return [Gitlab::ObjectifiedHash] Information about created wiki page.
    def create_wiki(project, title, content, options = {})
      body = { content: content, title: title }.merge(options)
      post("/projects/#{url_encode project}/wikis", body: body)
    end

    # Updates an existing wiki page. At least one parameter is required to update the wiki page.
    #
    # @example
    #   Gitlab.update_wiki(6, 'home', { title: 'New title' })
    #   Gitlab.update_wiki(6, 'home', { title: 'New title', content: 'New Message', format: 'rdoc' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] slug The slug (a unique string) of the wiki page.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] content The content of the wiki page.
    # @option options [String] title The title of the wiki page.
    # @option options [String] format (optional) The format of the wiki page. Available formats are: markdown (default), rdoc, and asciidoc.
    # @return [Gitlab::ObjectifiedHash] Information about updated wiki page.
    def update_wiki(project, slug, options = {})
      put("/projects/#{url_encode project}/wikis/#{slug}", body: options)
    end

    # Deletes a wiki page with a given slug.
    #
    # @example
    #   Gitlab.delete_wiki(42, 'foo')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] slug The slug (a unique string) of the wiki page.
    # @return [Gitlab::ObjectifiedHash] An empty objectified hash
    def delete_wiki(project, slug)
      delete("/projects/#{url_encode project}/wikis/#{slug}")
    end
  end
end
