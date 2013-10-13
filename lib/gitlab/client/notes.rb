class Gitlab::Client
  # Defines methods related to notes.
  module Notes
    # Gets a list of projects notes.
    #
    # @example
    #   Gitlab.notes(5)
    #
    # @param [Integer] project The ID of a project.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def notes(project)
      get("/projects/#{project}/notes")
    end

    # Gets a list of notes for a issue.
    #
    # @example
    #   Gitlab.issue_notes(5, 10)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] issue The ID of an issue.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def issue_notes(project, issue)
      get("/projects/#{project}/issues/#{issue}/notes")
    end

    # Gets a list of notes for a snippet.
    #
    # @example
    #   Gitlab.snippet_notes(5, 1)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] snippet The ID of a snippet.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def snippet_notes(project, snippet)
      get("/projects/#{project}/snippets/#{snippet}/notes")
    end

    # Gets a single wall note.
    #
    # @example
    #   Gitlab.note(5, 15)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] id The ID of a note.
    # @return [Gitlab::ObjectifiedHash]
    def note(project, id)
      get("/projects/#{project}/notes/#{id}")
    end

    # Gets a single issue note.
    #
    # @example
    #   Gitlab.issue_note(5, 10, 1)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] issue The ID of an issue.
    # @param [Integer] id The ID of a note.
    # @return [Gitlab::ObjectifiedHash]
    def issue_note(project, issue, id)
      get("/projects/#{project}/issues/#{issue}/notes/#{id}")
    end

    # Gets a single snippet note.
    #
    # @example
    #   Gitlab.snippet_note(5, 11, 3)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] snippet The ID of a snippet.
    # @param [Integer] id The ID of an note.
    # @return [Gitlab::ObjectifiedHash]
    def snippet_note(project, snippet, id)
      get("/projects/#{project}/snippets/#{snippet}/notes/#{id}")
    end

    # Creates a new wall note.
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] body The body of a note.
    # @return [Gitlab::ObjectifiedHash] Information about created note.
    def create_note(project, body)
      post("/projects/#{project}/notes", :body => {:body => body})
    end

    # Creates a new issue note.
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Integer] issue The ID of an issue.
    # @param  [String] body The body of a note.
    # @return [Gitlab::ObjectifiedHash] Information about created note.
    def create_issue_note(project, issue, body)
      post("/projects/#{project}/issues/#{issue}/notes", :body => {:body => body})
    end

    # Creates a new snippet note.
    #
    # @param  [Integer] project The ID of a project.
    # @param  [Integer] snippet The ID of a snippet.
    # @param  [String] body The body of a note.
    # @return [Gitlab::ObjectifiedHash] Information about created note.
    def create_snippet_note(project, snippet, body)
      post("/projects/#{project}/snippets/#{snippet}/notes", :body => {:body => body})
    end
  end
end
