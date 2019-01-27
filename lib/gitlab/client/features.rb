# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to feature flags.
  # https://docs.gitlab.com/ce/api/features.html
  module Features
    # Get a list of all persisted features, with its gate values.
    #
    # @example
    #   Gitlab.features
    #
    # @return [Array<Gitlab::ObjectifiedHash>]
    def features
      get('/features')
    end

    # Set a features gate value.
    # If a feature with the given name does not exist yet it will be created. The value can be a boolean, or an integer to indicate percentage of time.
    #
    # @example
    #   Gitlab.set_feature('new_library', true)
    #   Gitlab.set_feature('new_library', 8)
    #   Gitlab.set_feature('new_library', true, {user: 'gitlab'})
    #
    # @param  [String] name(required) Name of the feature to create or update
    # @param  [String, Integer] value(required) true or false to enable/disable, or an integer for percentage of time
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :feature_group(optional) A Feature group name
    # @option options [String] :user(optional) A GitLab username
    # @option options [String] :project(optional) A projects path, for example "gitlab-org/gitlab-ce"
    # @return [Gitlab::ObjectifiedHash] Information about the set/created/updated feature.
    def set_feature(name, value, options = {})
      body = { value: value }.merge(options)
      post("/features/#{name}", body: body)
    end

    # Delete a feature.
    #
    # @example
    #   Gitlab.delete_feature('new_library')
    #
    # @param  [String] name Name of the feature to delete
    # @return [void] This API call returns an empty response body.
    def delete_feature(name)
      delete("/features/#{name}")
    end
  end
end
