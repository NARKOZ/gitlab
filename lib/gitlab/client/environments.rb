# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to environments.
  # @see https://docs.gitlab.com/ce/api/environments.html
  module Environments
    # Gets a list of project environments.
    #
    # @example
    #   Gitlab.environments(5)
    #   Gitlab.environments(5, { per_page: 10, page:  2 })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def environments(project, options = {})
      get("/projects/#{url_encode project}/environments", query: options)
    end

    # Gets a single environment.
    #
    # @example
    #   Gitlab.environment(5, 36)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an environment.
    # @return [Gitlab::ObjectifiedHash]
    def environment(project, id)
      get("/projects/#{url_encode project}/environments/#{id}")
    end

    # Create an environment.
    #
    # @examples
    #   Gitlab.create_environment(5, 'test-branch')
    #   Gitlab.create_environment(5, 'test-branch', external_url: 'https://test-branch.example.host.com')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] env_name Name for the environment
    # @option options [String] :external_url Optional URL for viewing the deployed project in this environment
    # @return [Gitlab::ObjectifiedHash] The updated environment.
    def create_environment(project, env_name, options = {})
      body = { name: env_name }.merge(options)
      post("/projects/#{url_encode project}/environments", body: body)
    end

    # Update an environment.
    #
    # @examples
    #   Gitlab.edit_environment(5, 36, name: 'test-branch')
    #   Gitlab.edit_environment(5, 36, external_url: 'https://test-branch.example.host.com')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an environment.
    # @param  [Hash] options A hash of the attribute keys & values to update.
    # @option options [String] env_name Name for the environment
    # @option options [String] external_url Optional URL for viewing the deployed project in this environment
    # @return [Gitlab::ObjectifiedHash] The updated environment.
    def edit_environment(project, id, options = {})
      put("/projects/#{url_encode project}/environments/#{id}", body: options)
    end

    # Deletes an environment.
    #
    # @example
    #   Gitlab.delete_environment(5, 36)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an environment.
    # @return [Gitlab::ObjectifiedHash] Information about the deleted environment.
    def delete_environment(project, id)
      delete("/projects/#{url_encode project}/environments/#{id}")
    end

    # Stop an environment.
    #
    # @example
    #   Gitlab.stop_environment(5, 36)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an environment.
    # @return [Array<Gitlab::ObjectifiedHash>] The stopped environment.
    def stop_environment(project, id)
      post("/projects/#{url_encode project}/environments/#{id}/stop")
    end
  end
end
