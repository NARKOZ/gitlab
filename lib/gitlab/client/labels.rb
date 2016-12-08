class Gitlab::Client
  # Defines methods related to labels.
  # @see https://docs.gitlab.com/ce/api/labels.html
  module Labels
    # Gets a list of project's labels.
    #
    # @example
    #   Gitlab.labels(5)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def labels(project)
      get("/projects/#{url_encode project}/labels")
    end

    # Creates a new label.
    #
    # @example
    #   Gitlab.create_label(42, "Backlog", '#DD10AA')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @option [String] name The name of a label.
    # @option [String] color The color of a label.
    # @return [Gitlab::ObjectifiedHash] Information about created label.
    def create_label(project, name, color)
      post("/projects/#{url_encode project}/labels", body: { name: name, color: color })
    end

    # Updates a label.
    #
    # @example
    #   Gitlab.edit_label(42, "Backlog", { new_name: 'TODO' })
    #   Gitlab.edit_label(42, "Backlog", { new_name: 'TODO', color: '#DD10AA' })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] name The name of a label.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :new_name The new name of a label.
    # @option options [String] :color The color of a label.
    # @return [Gitlab::ObjectifiedHash] Information about updated label.
    def edit_label(project, name, options={})
      put("/projects/#{url_encode project}/labels", body: options.merge(name: name))
    end

    # Deletes a label.
    #
    # @example
    #   Gitlab.delete_label(2, 'Backlog')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] name The name of a label.
    # @return [Gitlab::ObjectifiedHash] Information about deleted label.
    def delete_label(project, name)
      delete("/projects/#{url_encode project}/labels", body: { name: name })
    end
  end
end
