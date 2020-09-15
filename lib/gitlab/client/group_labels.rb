# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to group labels.
  #
  # @note Requires GitLab 11.8+
  # @see https://docs.gitlab.com/ee/api/group_labels.html
  module GroupLabels
    # Gets a list of group's labels.
    #
    # @example
    #   Gitlab.group_labels('globex')
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def group_labels(group, options = {})
      get("/groups/#{url_encode group}/labels", query: options)
    end

    # Creates a new group label.
    #
    # @example
    #   Gitlab.create_group_label('globex', 'Backlog', '#DD10AA')
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [String] name The name of a label.
    # @param  [String] color The color of a label.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :description The description of the label.
    # @return [Gitlab::ObjectifiedHash] Information about created label.
    def create_group_label(group, name, color, options = {})
      post("/groups/#{url_encode group}/labels", body: options.merge(name: name, color: color))
    end

    # Updates a group label.
    #
    # @example
    #   Gitlab.edit_group_label('globex', 'Backlog', { new_name: 'Priority' })
    #   Gitlab.edit_group_label('globex', 'Backlog', { new_name: 'Priority', color: '#DD10AA' })
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [String] name The name of a label.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :new_name The new name of a label.
    # @option options [String] :color The color of a label.
    # @option options [String] :description The description of the label.
    # @return [Gitlab::ObjectifiedHash] Information about updated label.
    def edit_group_label(group, name, options = {})
      put("/groups/#{url_encode group}/labels", body: options.merge(name: name))
    end

    # Deletes a group label.
    #
    # @example
    #   Gitlab.delete_group_label('globex', 'Backlog')
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [String] name The name of a label.
    # @return [Gitlab::ObjectifiedHash] Information about deleted label.
    def delete_group_label(group, name)
      delete("/groups/#{url_encode group}/labels/#{name}")
    end

    # Subscribes the user to a group label to receive notifications
    #
    # @example
    #   Gitlab.subscribe_to_group_label('globex', 'Backlog')
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [String] name The name of a label.
    # @return [Gitlab::ObjectifiedHash] Information about the label subscribed to.
    def subscribe_to_group_label(group, name)
      post("/groups/#{url_encode group}/labels/#{url_encode name}/subscribe")
    end

    # Unsubscribes the user from a group label to not receive notifications from it
    #
    # @example
    #   Gitlab.unsubscribe_from_group_label('globex', 'Backlog')
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [String] name The name of a label.
    # @return [Gitlab::ObjectifiedHash] Information about the label unsubscribed from.
    def unsubscribe_from_group_label(group, name)
      post("/groups/#{url_encode group}/labels/#{url_encode name}/unsubscribe")
    end
  end
end
