# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to project labels.
  # @see https://docs.gitlab.com/ce/api/labels.html
  module Labels
    # Gets a list of project's labels.
    #
    # @example
    #   Gitlab.labels(5)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def labels(project, options = {})
      get("/projects/#{url_encode project}/labels", query: options)
    end

    # Creates a new label.
    #
    # @example
    #   Gitlab.create_label(42, "Backlog", '#DD10AA')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] name The name of a label.
    # @param  [String] color The color of a label.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :description The description of the label.
    # @option options [String] :priority The priority of the label. Must be greater or equal than zero or null to remove the priority.
    # @return [Gitlab::ObjectifiedHash] Information about created label.
    def create_label(project, name, color, options = {})
      post("/projects/#{url_encode project}/labels", body: options.merge(name: name, color: color))
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
    # @option options [String] :description The description of the label.
    # @option options [String] :priority The priority of the label. Must be greater or equal than zero or null to remove the priority.
    # @return [Gitlab::ObjectifiedHash] Information about updated label.
    def edit_label(project, name, options = {})
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
      delete("/projects/#{url_encode project}/labels/#{name}")
    end

    # Subscribes the user to a label to receive notifications
    #
    # @example
    #   Gitlab.subscribe_to_label(2, 'Backlog')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] name The name of a label.
    # @return [Gitlab::ObjectifiedHash] Information about the label subscribed to.
    def subscribe_to_label(project, name)
      post("/projects/#{url_encode project}/labels/#{url_encode name}/subscribe")
    end

    # Unsubscribes the user from a label to not receive notifications from it
    #
    # @example
    #   Gitlab.unsubscribe_from_label(2, 'Backlog')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] name The name of a label.
    # @return [Gitlab::ObjectifiedHash] Information about the label unsubscribed from.
    def unsubscribe_from_label(project, name)
      post("/projects/#{url_encode project}/labels/#{url_encode name}/unsubscribe")
    end
  end
end
