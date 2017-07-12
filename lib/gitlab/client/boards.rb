class Gitlab::Client
  # Defines methods related to issue boards.
  # @see https://docs.gitlab.com/ce/api/boards.html
  module Boards
    # Gets a list of project's boards.
    #
    # @example
    #   Gitlab.boards(5)
    #   Gitlab.boards({ per_page: 40 })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def boards(project, options={})
      get("/projects/#{url_encode project}/boards", query: options)
    end

    # Gets a board lists
    #
    # @example
    #   Gitlab.board_lists(5, 42)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a board.
    # @return [Gitlab::ObjectifiedHash]
    def board_lists(project, id)
      get("/projects/#{url_encode project}/boards/#{id}/lists")
    end
    #
    # Gets a single board list
    #
    # @example
    #   Gitlab.board_list(5, 42, 25)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] board_id The ID of a board.
    # @param  [Integer] id The ID of a list.
    # @return [Gitlab::ObjectifiedHash]
    def board_list(project, board_id, id)
      get("/projects/#{url_encode project}/boards/#{board_id}/lists/#{id}")
    end

    # Creates a new board list.
    # Only for admins and project owners
    #
    # @example
    #   Gitlab.create_board_list(5, 42, 25)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a board.
    # @param  [Integer] label_id The ID of a label.
    # @return [Gitlab::ObjectifiedHash] Information about created list.
    def create_board_list(project, board_id, label_id)
      post("/projects/#{url_encode project}/boards/#{board_id}/lists", body: {label_id: label_id})
    end

    # Updates a board list.
    # Only for admins and project owners
    #
    # @example
    #   Gitlab.edit_board_list(6, 1, 12, 5)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] board_id The ID of a board.
    # @param  [Integer] id The ID of a list.
    # @return [Gitlab::ObjectifiedHash] Information about updated board list.
    def edit_board_list(project, board_id, id, position)
      put("/projects/#{url_encode project}/boards/#{board_id}/lists/#{id}", body: {position: position})
    end

    # Deletes  a board list.
    # Only for admins and project owners
    #
    # @example
    #   Gitlab.delete_board_list(3, 42, 32)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] board_id The ID of a board.
    # @param  [Integer] id The ID of a list.
    # @return [Gitlab::ObjectifiedHash] Information about deleted board list.
    def delete_board_list(project, board_id, id)
      delete("/projects/#{url_encode project}/boards/#{board_id}/lists/#{id}")
    end
  end
end

