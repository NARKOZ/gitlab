# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to todos
  # @see https://docs.gitlab.com/ce/api/todos.html
  module Todos
    # Gets a list of todos.
    #
    # @example
    #   Gitlab.todos
    #   Gitlab.todos({ action: 'assigned' })
    #   Gitlab.todos({ state: 'pending' })
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :action The action to be filtered. Can be `assigned`, `mentioned`, `build_failed`, `marked`, or `approval_required`.
    # @option options [Integer] :author_id The ID of an author
    # @option options [Integer] :project_id The ID of a project
    # @option options [Integer] :state The state of the todo. Can be either `pending` or `done`
    # @option options [Integer] :type The type of a todo. Can be either `Issue` or `MergeRequest`
    # @return [Array<Gitlab::ObjectifiedHash>]
    def todos(options = {})
      get('/todos', query: options)
    end

    # Marks a single pending todo for the current user as done.
    #
    # @example
    #   Gitlab.mark_todo_as_done(42)
    #
    # @param  [Integer] id The ID of the todo.
    # @return [Gitlab::ObjectifiedHash]
    def mark_todo_as_done(id)
      post("/todos/#{id}/mark_as_done")
    end

    # Marks all todos for the current user as done
    #
    # @example
    #   Gitlab.mark_all_todos_as_done
    #
    # @return [void] This API call returns an empty response body.
    def mark_all_todos_as_done
      post('/todos/mark_as_done')
    end
  end
end
