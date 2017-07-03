class Gitlab::Client
  # Defines methods related to Award Emojis.
  # @see https://docs.gitlab.com/ce/api/award_emoji.html
  module AwardEmojis
    # Gets a list of all award emoji for an issue
    #
    # @example
    #   Gitlab.issue_award_emojis(1, 80)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] issue_id The ID of an issue.
    # @return [Array<Gitlab::ObjectifiedHash>]
    # def issue_award_emojis(project, issue_id)
    #   get("/projects/#{url_encode project}/issues/#{issue_id}/award_emoji")
    # end

    # Gets a list of all award emoji for a merge request
    #
    # @example
    #   Gitlab.merge_request_award_emojis(1, 80)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] merge_request_id The ID of a merge request.
    # @return [Array<Gitlab::ObjectifiedHash>]
    # def merge_request_award_emojis(project, merge_request_id)
    #   get("/projects/#{url_encode project}/merge_requests/#{merge_request_id}/award_emoji")
    # end

    # Gets a list of all award emoji for a snippet
    #
    # @example
    #   Gitlab.snippet_award_emojis(1, 80)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] snippet_id The ID of a snippet.
    # @return [Array<Gitlab::ObjectifiedHash>]
    # def snippet_award_emojis(project, snippet_id)
    #   get("/projects/#{url_encode project}/snippets/#{snippet_id}/award_emoji")
    # end

    # Gets a single award emoji for an issue
    #
    # @example
    #   Gitlab.issue_award_emoji(1, 80, 4)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] issue_id The ID of an issue.
    # @param [Integer] award_id The ID of an award emoji.
    # @return [Gitlab::ObjectifiedHash]
    # def issue_award_emoji(project, issue_id, award_id)
    #   get("/projects/#{url_encode project}/issues/#{issue_id}/award_emoji/#{award_id}")
    # end

    # Gets a single award emoji for a merge request
    #
    # @example
    #   Gitlab.merge_request_award_emoji(1, 80, 4)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] merge_request_id The ID of a merge request.
    # @param [Integer] award_id The ID of an award emoji.
    # @return [Gitlab::ObjectifiedHash]
    # def merge_request_award_emoji(project, merge_request_id, award_id)
    #   get("/projects/#{url_encode project}/merge_requests/#{merge_request_id}/award_emoji/#{award_id}")
    # end

    # Gets a single award emoji for a snippet
    #
    # @example
    #   Gitlab.snippet_award_emoji(1, 80, 4)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] snippet_id The ID of a snippet.
    # @param [Integer] award_id The ID of an award emoji.
    # @return [Gitlab::ObjectifiedHash]
    # def snippet_award_emoji(project, snippet_id, award_id)
    #   get("/projects/#{url_encode project}/snippets/#{snippet_id}/award_emoji")
    # end

    # Awards a new emoji to an issue
    #
    # @example
    #   Gitlab.create_issue_emoji(1, 80, 'blowfish')
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] issue_id The ID of an issue.
    # @param [String] emoji_name The name of the emoji, without colons.
    # @return [Gitlab::ObjectifiedHash]
    def create_issue_emoji(project, issue_id, emoji_name)
      post("/projects/#{url_encode project}/issues/#{issue_id}", body: {name: emoji_name})
    end

    # Awards a new emoji to a merge request
    #
    # @example
    #   Gitlab.create_merge_request_emoji(1, 80, 'blowfish')
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] merge_request_id The ID of a merge request.
    # @param [String] emoji_name The name of the emoji, without colons.
    # @return [Gitlab::ObjectifiedHash]
    def create_merge_request_emoji(project, issue_id, emoji_name)
      post("/projects/#{url_encode project}/merge_requests/#{merge_request_id}", body: {name: emoji_name})
    end

    # Awards a new emoji to a snippet
    #
    # @example
    #   Gitlab.create_snippet_emoji(1, 80, 'blowfish')
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] merge_request_id The ID of a merge request.
    # @param [String] emoji_name The name of the emoji, without colons.
    # @return [Gitlab::ObjectifiedHash]
    def create_merge_request_emoji(project, merge_request_id, emoji_name)
      post("/projects/#{url_encode project}/merge_requests/#{merge_request_id}", body: {name: emoji_name})
    end
  end
end