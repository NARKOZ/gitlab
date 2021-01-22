# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to Protected Tags.
  # @see https://docs.gitlab.com/ce/api/protected_tags.html
  module ProtectedTags
    # Gets a list of protected tags from a project
    #
    # @example
    #   Gitlab::Client.protected_tags(1)
    #
    # @param [Integer, String] project(required) The ID or name of a project.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::Client::ObjectifiedHash>] List of all protected tags requested
    def protected_tags(project, options = {})
      get("/projects/#{url_encode project}/protected_tags", query: options)
    end

    # Gets a single protected tag or wildcard protected tag.
    #
    # @example
    #   Gitlab::Client.protected_tag(1, 'release-1-0')
    #
    # @param [Integer, String] project(required) The ID or name of a project.
    # @param [String] name(required) The name of the tag or wildcard
    # @return <Gitlab::Client::ObjectifiedHash] Information about the requested protected tag
    def protected_tag(project, name)
      get("/projects/#{url_encode project}/protected_tags/#{name}")
    end

    # Protects a single repository tag or several project repository tags using a wildcard protected tag.
    #
    # @example
    #    Gitlab::Client.protect_repository_tag(1, 'release-1-0')
    #    Gitlab::Client.protect_repository_tag(1, 'release-1-0', create_access_level: 30)
    #
    # @param [Integer, String] project(required) The ID or name of a project.
    # @param [String] name(required) The name of the tag or wildcard
    # @option options [Integer] :create_access_level Access levels allowed to create (defaults: 40, maintainer access level)
    # @return <Gitlab::Client::ObjectifiedHash] Information about the protected repository tag
    def protect_repository_tag(project, name, options = {})
      body = { name: name }.merge(options)
      post("/projects/#{url_encode project}/protected_tags", body: body)
    end

    # Unprotects the given protected tag or wildcard protected tag.
    #
    # @example
    #    Gitlab::Client.unprotect_repository_tag(1, 'release-1-0')
    #
    # @param [Integer, String] project(required) The ID or name of a project.
    # @param [String] name(required) The name of the tag or wildcard
    # @return [nil] This API call returns an empty response body.
    def unprotect_repository_tag(project, name)
      delete("/projects/#{url_encode project}/protected_tags/#{name}")
    end
  end
end
