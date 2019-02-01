# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to project releases and project release assets(links).
  # @see https://docs.gitlab.com/ce/api/releases/
  # @see https://docs.gitlab.com/ce/api/releases/links.html

  module ProjectReleases
    # Returns Paginated list of a project's releases, sorted by created_at.
    #
    # @example
    #   Gitlab.project_releases(5)
    #
    # @param [Integer, String] project The ID or name of a project.
    # @return [Array<Gitlab::ObjectifiedHash>] Paginated list of Releases, sorted by created_at.
    def project_releases(project)
      get("/projects/#{url_encode project}/releases")
    end

    # Gets a Release by a tag name
    #
    # @example
    #   Gitlab.project_release(5, 'v0.1')
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [String] tag_name  The tag where the release will be created from..
    # @return [Gitlab::ObjectifiedHash] Information about the release
    def project_release(project, tag_name)
      get("/projects/#{url_encode project}/releases/#{tag_name}")
    end

    # Creates a Release. You need push access to the repository to create a Release.
    #
    # @example
    #   Gitlab.create_project_release(5, { name: 'New Release', tag_name: 'v0.3', description: 'Super nice release' })
    #   Gitlab.create_project_release(5, { name: 'New Release', tag_name: 'v0.3', description: 'Super nice release', assets: { links: [{ name: 'hoge', url: 'https://google.com' }] } })
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :name(required)  The release name.
    # @option options [String] :tag_name(required)  The tag where the release will be created from.
    # @option options [String] :description(required)  The description of the release. You can use markdown.
    # @option options [String] :ref(optional)  If tag_name does not exist, the release will be created from ref. It can be a commit SHA, another tag name, or a branch name.
    # @option options [Hash] :assets(optional) A customizable set of options for release assets
    # @asset assets [Array<link>] :links(optional)  An array of assets links as hashes.
    # @link links [Hash] link_elements A combination of a link name and a link url
    # @link_element [String] :name The name of the link.
    # @link_element [String] :url The url of the link.
    # @return [Gitlab::ObjectifiedHash] Information about the created release.
    def create_project_release(project, options = {})
      post("/projects/#{url_encode project}/releases", body: options)
    end

    # Updates a release.
    #
    # @example
    #   Gitlab.update_project_release(5, 'v0.3', { name: 'New Release', description: 'Super nice release' })
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [String] tag_name  The tag where the release will be created from.
    # @param [Hash] options A customizable set of options.
    # @option options [String] :name(optional)  The release name.
    # @option options [String] :description(optional)  The description of the release. You can use markdown.
    # @return [Gitlab::ObjectifiedHash] Information about the updated release.
    def update_project_release(project, tag_name, options = {})
      put("/projects/#{url_encode project}/releases/#{tag_name}", body: options)
    end

    # Delete a Release. Deleting a Release will not delete the associated tag.
    #
    # @example
    #   Gitlab.delete_project_release(5, 'v0.3')
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [String] tag_name  The tag where the release will be created from.
    # @return [Gitlab::ObjectifiedHash] Information about the deleted release.
    def delete_project_release(project, tag_name)
      delete("/projects/#{url_encode project}/releases/#{tag_name}")
    end

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
