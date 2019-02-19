# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to group issue boards.
  # @see https://docs.gitlab.com/ee/api/group_boards.html
  module GroupBoards
    # Lists Issue Boards in the given group.
    #
    # @example
    #   Gitlab.group_boards(5)
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @return [Array<Gitlab::ObjectifiedHash>] List of issue boards of the group
    def group_boards(group)
      get("/groups/#{url_encode group}/boards")
    end

    # Gets a single group issue board.
    #
    # @example
    #   Gitlab.group_board(5, 1)
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [Integer] id The ID of the issue board.
    # @return [Gitlab::ObjectifiedHash] Returns information about a group issue board
    def group_board(group, id)
      get("/groups/#{url_encode group}/boards/#{id}")
    end

    # Creates a new group issue board.
    #
    # @example
    #   Gitlab.create_group_board(5, 'Documentcloud')
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [String] name The name of the new board.
    # @return [Gitlab::ObjectifiedHash] Information about created group issue board.
    def create_group_board(group, name)
      body = { name: name }
      post("/groups/#{url_encode group}/boards", body: body)
    end

    # Updates a group issue board.
    #
    # @example
    #   Gitlab.edit_group_board(5, 1, { name: 'DocumentCloud2' })
    #   Gitlab.edit_group_board(5, 1, { name: 'DocumentCloud2', assignee_id: 3 })
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [Integer] id The ID of the issue board.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :name(optional) The new name of the board.
    # @option options [Integer] :assignee_id(optional) The assignee the board should be scoped to.
    # @option options [Integer] :milestone_id(optional) The milestone the board should be scoped to.
    # @option options [String] :labels(optional) Comma-separated list of label names which the board should be scoped to.
    # @option options [Integer] :weight(optional) The weight range from 0 to 9, to which the board should be scoped to.
    # @return [Gitlab::ObjectifiedHash] Information about updated group issue board.
    def edit_group_board(group, id, options = {})
      put("/groups/#{url_encode group}/boards/#{id}", body: options)
    end

    # Deletes a group issue board.
    #
    # @example
    #   Gitlab.delete_group_board(5, 1)
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [Integer] id The ID of the issue board.
    # @return [void] This API call returns an empty response body.
    def delete_group_board(group, id)
      delete("/groups/#{url_encode group}/boards/#{id}")
    end

    # Get a list of the boards lists. Does not include open and closed lists
    #
    # @example
    #   Gitlab.group_board_lists(5, 1)
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [Integer] board_id The ID of the group issue board.
    # @return [Array<Gitlab::ObjectifiedHash>] List of boards lists of the group
    def group_board_lists(group, board_id)
      get("/groups/#{url_encode group}/boards/#{board_id}/lists")
    end

    # Get a single group issue board list.
    #
    # @example
    #   Gitlab.group_board_list(5, 1, 1)
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [Integer] board_id The ID of the group issue board.
    # @param  [Integer] list_id The ID of a boards list.
    # @return [Gitlab::ObjectifiedHash] Returns information about a single group issue board list
    def group_board_list(group, board_id, id)
      get("/groups/#{url_encode group}/boards/#{board_id}/lists/#{id}")
    end

    # Creates a new group issue board list.
    #
    # @example
    #   Gitlab.create_group_board_list(5, 1)
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [Integer] board_id The ID of the group issue board.
    # @param  [Integer] label_id The ID of a label.
    # @return [Gitlab::ObjectifiedHash] Information about created group issue board list.
    def create_group_board_list(group, board_id, label_id)
      body = { label_id: label_id }
      post("/groups/#{url_encode group}/boards/#{board_id}/lists", body: body)
    end

    # Updates an existing group issue board list. This call is used to change list position.
    #
    # @example
    #   Gitlab.edit_group_board_list(5, 1, 1, { position: 1 })
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [Integer] board_id The ID of the group issue board.
    # @param  [Integer] list_id The ID of a boards list.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :position(required) The position of the list.
    # @return [Gitlab::ObjectifiedHash] Information about updated group issue board list.
    def edit_group_board_list(group, board_id, id, options = {})
      put("/groups/#{url_encode group}/boards/#{board_id}/lists/#{id}", body: options)
    end

    # Deletes a group issue board list.
    #
    # @example
    #   Gitlab.delete_group_board_list(5, 1, 1)
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [Integer] board_id The ID of the group issue board.
    # @param  [Integer] list_id The ID of a boards list.
    # @return [void] This API call returns an empty response body.
    def delete_group_board_list(group, board_id, id)
      delete("/groups/#{url_encode group}/boards/#{board_id}/lists/#{id}")
    end
  end
end
