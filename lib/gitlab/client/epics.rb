# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to Epics.
  # @see https://docs.gitlab.com/ee/api/epics.html
  module Epics
    # Gets a list of epics.
    #
    # @example
    #   Gitlab.epics(123)
    #   Gitlab.epics(123, { per_page: 40, page: 2 })
    #
    # @param  [Integer] group_id The ID of a group.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def epics(group_id, options = {})
      get("/groups/#{group_id}/epics", query: options)
    end

    # Gets a single epic.
    #
    # @example
    #   Gitlab.epic(123, 1)
    #
    # @param  [Integer] group_id The ID of a group.
    # @param  [Integer] epic_iid The ID of a epic.
    # @param  [Hash] options A customizable set of options.
    # @return [Gitlab::ObjectifiedHash]
    def epic(group_id, epic_iid, options = {})
      get("/groups/#{group_id}/epics/#{epic_iid}", query: options)
    end

    # Creates a new epic.
    #
    # @example
    #   Gitlab.create_epic(123, "My new epic title")
    #
    # @param  [Integer] group_id The ID of a group.
    # @param  [String] title
    # @param  [Hash] options A customizable set of options.
    # @return [Gitlab::ObjectifiedHash] Information about created epic.
    def create_epic(group_id, title, options = {})
      body = options.merge(title: title)
      post("/groups/#{group_id}/epics", body: body)
    end

    # Deletes an epic.
    #
    # @example
    #   Gitlab.delete_epic(42, 123)
    # @param  [Integer] group_id The ID of a group.
    # @param  [Integer] epic_iid The IID of an epic.
    def delete_epic(group_id, epic_iid)
      delete("/groups/#{group_id}/epics/#{epic_iid}")
    end

    # Updates an existing epic.
    #
    # @example
    #   Gitlab.edit_epic(42)
    #   Gitlab.edit_epic(42, 123, { title: 'New epic title' })
    #
    # @param  [Integer] group_id The ID.
    # @param  [Integer] epic_iid The IID of an epic.
    # @param  [Hash] options A customizable set of options
    # @return [Gitlab::ObjectifiedHash] Information about the edited epic.
    def edit_epic(group_id, epic_iid, options = {})
      put("/groups/#{group_id}/epics/#{epic_iid}", body: options)
    end
  end
end
