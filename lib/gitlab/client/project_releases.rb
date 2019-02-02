# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to project releases.
  # @see https://docs.gitlab.com/ce/api/releases/
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
  end
end
