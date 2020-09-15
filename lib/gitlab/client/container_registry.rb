# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to GitLab Container Registry.
  # @see https://docs.gitlab.com/ce/api/container_registry.html
  module ContainerRegistry
    # Get a list of registry repositories in a project.
    #
    # @example
    #   Gitlab.registry_repositories(5)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @return [Array<Gitlab::ObjectifiedHash>] Returns list of registry repositories in a project.
    def registry_repositories(project)
      get("/projects/#{url_encode project}/registry/repositories")
    end

    # Delete a repository in registry.
    #
    # @example
    #   Gitlab.delete_registry_repository(5, 2)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of registry repository.
    # @return [void] This API call returns an empty response body.
    def delete_registry_repository(project, id)
      delete("/projects/#{url_encode project}/registry/repositories/#{id}")
    end

    # Get a list of tags for given registry repository.
    #
    # @example
    #   Gitlab.registry_repository_tags(5, 2)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] repository_id The ID of registry repository.
    # @return [Array<Gitlab::ObjectifiedHash>] Returns list of tags of a registry repository.
    def registry_repository_tags(project, repository_id)
      get("/projects/#{url_encode project}/registry/repositories/#{repository_id}/tags")
    end

    # Get details of a registry repository tag.
    #
    # @example
    #   Gitlab.registry_repository_tag(5, 2, 'v10.0.0')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] repository_id The ID of registry repository.
    # @param  [String] tag_name The name of tag.
    # @return <Gitlab::ObjectifiedHash> Returns details about the registry repository tag
    def registry_repository_tag(project, repository_id, tag_name)
      get("/projects/#{url_encode project}/registry/repositories/#{repository_id}/tags/#{tag_name}")
    end

    # Delete a registry repository tag.
    #
    # @example
    #   Gitlab.delete_registry_repository_tag(5, 2, 'v10.0.0')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] repository_id The ID of registry repository.
    # @param  [String] tag_name The name of tag.
    # @return [void] This API call returns an empty response body.
    def delete_registry_repository_tag(project, repository_id, tag_name)
      delete("/projects/#{url_encode project}/registry/repositories/#{repository_id}/tags/#{tag_name}")
    end

    # Delete repository tags in bulk based on given criteria.
    #
    # @example
    #   Gitlab.bulk_delete_registry_repository_tags(5, 2, name_regex: '.*')
    #   Gitlab.bulk_delete_registry_repository_tags(5, 2, name_regex: '[0-9a-z]{40}', keep_n: 5, older_than: '1d')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] repository_id The ID of registry repository.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :name_regex(required) The regex of the name to delete. To delete all tags specify .*.
    # @option options [Integer] :keep_n(optional) The amount of latest tags of given name to keep.
    # @option options [String] :older_than(required) Tags to delete that are older than the given time, written in human readable form 1h, 1d, 1month.
    # @return [void] This API call returns an empty response body.
    def bulk_delete_registry_repository_tags(project, repository_id, options = {})
      delete("/projects/#{url_encode project}/registry/repositories/#{repository_id}/tags", body: options)
    end
  end
end
