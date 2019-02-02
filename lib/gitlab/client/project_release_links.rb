# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to project release links.
  # @see https://docs.gitlab.com/ce/api/releases/links.html
  module ProjectReleaseLinks
    # Get assets as links from a Release.
    #
    # @example
    #   Gitlab.project_release_links(5, 'v0.3')
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [String] tag_name The tag associated with the Release.
    # @return [Array<Gitlab::ObjectifiedHash>] List of assets as links from a Release.
    def project_release_links(project, tag_name)
      get("/projects/#{url_encode project}/releases/#{tag_name}/assets/links")
    end

    # Get an asset as link from a Release.
    #
    # @example
    #   Gitlab.project_release_link(5, 'v0.3', 1)
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [String] tag_name The tag associated with the Release.
    # @param [Integer] link_id The id of the link.
    # @return [Gitlab::ObjectifiedHash] Information about the release link
    def project_release_link(project, tag_name, link_id)
      get("/projects/#{url_encode project}/releases/#{tag_name}/assets/links/#{link_id}")
    end

    # Create an asset as a link from a Release.
    #
    # @example
    #   Gitlab.create_project_release_link(5, 'v0.1', { name: 'awesome-v0.2.dmg', url: 'http://192.168.10.15:3000' })
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [String] tag_name The tag associated with the Release.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :name(required)  The name of the link.
    # @option options [String] :url(required)  The URL of the link.
    # @return [Gitlab::ObjectifiedHash] Information about the created release link.
    def create_project_release_link(project, tag_name, options = {})
      post("/projects/#{url_encode project}/releases/#{tag_name}/assets/links", body: options)
    end

    # Update an asset as a link from a Release. You have to specify at least one of name or url
    #
    # @example
    #   Gitlab.update_project_release_link(5, 'v0.3', 1, { name: 'awesome-v0.2.dmg', url: 'http://192.168.10.15:3000' })
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [String] tag_name  The tag where the release will be created from.
    # @param [Integer] link_id The id of the link.
    # @param [Hash] options A customizable set of options.
    # @option options [String] :name(optional)  The name of the link.
    # @option options [String] :url(optional)  The URL of the link.
    # @return [Gitlab::ObjectifiedHash] Information about the updated release link.
    def update_project_release_link(project, tag_name, link_id, options = {})
      put("/projects/#{url_encode project}/releases/#{tag_name}/assets/links/#{link_id}", body: options)
    end

    # Delete an asset as a link from a Release.
    #
    # @example
    #   Gitlab.delete_project_release_link(5, 'v0.3', 1)
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [String] tag_name  The tag where the release will be created from.
    # @param [Integer] link_id The id of the link.
    # @return [Gitlab::ObjectifiedHash] Information about the deleted release link.
    def delete_project_release_link(project, tag_name, link_id)
      delete("/projects/#{url_encode project}/releases/#{tag_name}/assets/links/#{link_id}")
    end
  end
end
