class Gitlab::Client
  # Defines methods related to builds.
  # @see https://docs.gitlab.com/ce/api/build_variables.html
  # @see https://docs.gitlab.com/ee/api/group_level_variables.html
  module BuildVariables
    # Gets a list of the project's build variables
    #
    # @example
    #   Gitlab.variables(5)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @return [Array<Gitlab::ObjectifiedHash>] The list of variables.
    def variables(project)
      get("/projects/#{url_encode project}/variables")
    end

    # Gets details of a project's specific build variable.
    #
    # @example
    #   Gitlab.variable(5, "TEST_VARIABLE_1")
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] key The key of a variable.
    # @return [Gitlab::ObjectifiedHash] The variable.
    def variable(project, key)
      get("/projects/#{url_encode project}/variables/#{key}")
    end

    # Create a build variable for a project.
    #
    # @example
    #   Gitlab.create_variable(5, "NEW_VARIABLE", "new value")
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] key The key of a variable; must have no more than 255 characters; only `A-Z`, `a-z`, `0-9` and `_` are allowed
    # @param  [String] value The value of a variable
    # @return [Gitlab::ObjectifiedHash] The variable.
    def create_variable(project, key, value)
      post("/projects/#{url_encode project}/variables", body: { key: key, value: value })
    end

    # Update a project's build variable.
    #
    # @example
    #   Gitlab.update_variable(5, "NEW_VARIABLE", "updated value")
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] key The key of a variable
    # @param  [String] value The value of a variable
    # @return [Gitlab::ObjectifiedHash] The variable.
    def update_variable(project, key, value)
      put("/projects/#{url_encode project}/variables/#{key}", body: { value: value })
    end

    # Remove a project's build variable.
    #
    # @example
    #   Gitlab.remove_variable(5, "VARIABLE_1")
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] key The key of a variable.
    # @return [Gitlab::ObjectifiedHash] The variable.
    def remove_variable(project, key)
      delete("/projects/#{url_encode project}/variables/#{key}")
    end

    # Gets a list of the group's build variables
    #
    # @example
    #   Gitlab.group_variables(5)
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @return [Array<Gitlab::ObjectifiedHash>] The list of variables.
    def group_variables(group)
      get("/groups/#{url_encode group}/variables")
    end

    # Gets details of a group's specific build variable.
    #
    # @example
    #   Gitlab.group_variable(5, "TEST_VARIABLE_1")
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [String] key The key of a variable.
    # @return [Gitlab::ObjectifiedHash] The variable.
    def group_variable(group, key)
      get("/groups/#{url_encode group}/variables/#{key}")
    end

    # Create a build variable for a group.
    #
    # @example
    #   Gitlab.create_group_variable(5, "NEW_VARIABLE", "new value")
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [String] key The key of a variable; must have no more than 255 characters; only `A-Z`, `a-z`, `0-9` and `_` are allowed
    # @param  [String] value The value of a variable
    # @return [Gitlab::ObjectifiedHash] The variable.
    def create_group_variable(group, key, value)
      post("/groups/#{url_encode group}/variables", body: { key: key, value: value })
    end

    # Update a group's build variable.
    #
    # @example
    #   Gitlab.update_group_variable(5, "NEW_VARIABLE", "updated value")
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [String] key The key of a variable
    # @param  [String] value The value of a variable
    # @return [Gitlab::ObjectifiedHash] The variable.
    def update_group_variable(group, key, value)
      put("/groups/#{url_encode group}/variables/#{key}", body: { value: value })
    end

    # Remove a group's build variable.
    #
    # @example
    #   Gitlab.remove_group_variable(5, "VARIABLE_1")
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [String] key The key of a variable.
    # @return [Gitlab::ObjectifiedHash] The variable.
    def remove_group_variable(group, key)
      delete("/groups/#{url_encode group}/variables/#{key}")
    end
  end
end
