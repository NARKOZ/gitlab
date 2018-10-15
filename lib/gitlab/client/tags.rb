# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to tags.
  # @see https://docs.gitlab.com/ce/api/tags.html
  module Tags
    # Gets a list of project repository tags.
    #
    # @example
    #   Gitlab.tags(42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def tags(project, options = {})
      get("/projects/#{url_encode project}/repository/tags", query: options)
    end
    alias repo_tags tags

    # Creates a new project repository tag.
    #
    # @example
    #   Gitlab.create_tag(42, 'new_tag', 'master')
    #   Gitlab.create_tag(42, 'v1.0', 'master', 'Release 1.0')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String]  tag_name The name of the new tag.
    # @param  [String]  ref The ref (commit sha, branch name, or another tag) the tag will point to.
    # @param  [String]  message Optional message for tag, creates annotated tag if specified.
    # @param  [String]  description Optional release notes for tag.
    # @return [Gitlab::ObjectifiedHash]
    def create_tag(project, tag_name, ref, message = '', description = nil)
      post("/projects/#{url_encode project}/repository/tags", body: { tag_name: tag_name, ref: ref, message: message, release_description: description })
    end
    alias repo_create_tag create_tag

    # Gets information about a repository tag.
    #
    # @example
    #   Gitlab.tag(3, 'api')
    #   Gitlab.repo_tag(5, 'master')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] tag The name of the tag.
    # @return [Gitlab::ObjectifiedHash]
    def tag(project, tag)
      get("/projects/#{url_encode project}/repository/tags/#{url_encode tag}")
    end
    alias repo_tag tag

    # Deletes a repository tag.  Requires Gitlab >= 6.8.x
    #
    # @example
    #   Gitlab.delete_tag(3, 'api')
    #   Gitlab.repo_delete_tag(5, 'master')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] tag The name of the tag to delete
    # @return [Gitlab::ObjectifiedHash]
    def delete_tag(project, tag)
      delete("/projects/#{url_encode project}/repository/tags/#{url_encode tag}")
    end
    alias repo_delete_tag delete_tag

    # Adds release notes to an existing repository tag.  Requires Gitlab >= 8.2.0
    #
    # @example
    #   Gitlab.create_release(3, '1.0.0', 'This is ready for production')
    #   Gitlab.repo_create_release(5, '1.0.0', 'This is ready for production')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] tag The name of the new tag.
    # @param  [String] description Release notes with markdown support
    # @return [Gitlab::ObjectifiedHash]
    def create_release(project, tag, description)
      post("/projects/#{url_encode project}/repository/tags/#{url_encode tag}/release", body: { description: description })
    end
    alias repo_create_release create_release

    # Updates the release notes of a given release.  Requires Gitlab >= 8.2.0
    #
    # @example
    #   Gitlab.update_release(3, '1.0.0', 'This is even more ready for production')
    #   Gitlab.repo_update_release(5, '1.0.0', 'This is even more ready for production')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] tag The name of the new tag.
    # @param  [String] description Release notes with markdown support
    # @return [Gitlab::ObjectifiedHash]
    def update_release(project, tag, description)
      put("/projects/#{url_encode project}/repository/tags/#{url_encode tag}/release", body: { description: description })
    end
    alias repo_update_release update_release
  end
end
