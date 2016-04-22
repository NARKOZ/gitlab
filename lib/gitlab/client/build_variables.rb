class Gitlab::Client
  # Defines methods related to builds.
  # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/build_variables.md
  module BuildVariables
    # Gets a list of the project's build variables
    #
    # @example
    #   Gitlab.variables(5)
    #
    # @param  [Integer] project The ID of a project.
    # @return [Array<Gitlab::ObjectifiedHash>] The list of variables.
    def variables(project)
      get("/projects/#{project}/variables")
    end

    # Gets details of a project's specific build variable.
    #
    # @example
    #   Gitlab.build(5, "TEST_VARIABLE_1")
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] key The key of a variable.
    # @return [Gitlab::ObjectifiedHash] The variable.
    def variable(project, key)
      get("/projects/#{project}/variables/#{key}")
    end

    # Create a build variable for a project.
    #
    # @example
    #   Gitlab.create_variable(5, "NEW_VARIABLE", "new value")
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] key The key of a variable; must have no more than 255 characters; only `A-Z`, `a-z`, `0-9` and `_` are allowed
    # @param  [String] value The value of a variable
    # @return [Gitlab::ObjectifiedHash] The variable.
    def create_variable(project, key, value)
      post("/projects/#{project}/variables", body: { key: key, value: value })
    end

    # Update a project's build variable.
    #
    # @example
    #   Gitlab.create_variable(5, "NEW_VARIABLE", "updated value")
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] key The key of a variable
    # @param  [String] value The value of a variable
    # @return [Gitlab::ObjectifiedHash] The variable.
    def update_variable(project, key, value)
      put("/projects/#{project}/variables/#{key}", body: { value: value })
    end

    # Remove a project's build variable.
    #
    # @example
    #   Gitlab.remove_variable(5, "VARIABLE_1")
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] key The key of a variable.
    # @return [Gitlab::ObjectifiedHash] The variable.
    def remove_variable(project, key)
      delete("/projects/#{project}/variables/#{key}")
    end
  end
end
