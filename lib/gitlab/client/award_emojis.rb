# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to Award Emojis.
  # @see https://docs.gitlab.com/ce/api/award_emoji.html
  module AwardEmojis
    # Gets a list of all award emoji for an awardable(issue, merge request or snippet)
    #
    # @example
    #   Gitlab.award_emojis(1, 80, 'issue')
    #   Gitlab.award_emojis(1, 60, 'merge_request')
    #   Gitlab.award_emojis(1, 40, 'snippet')
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] awardable_id The ID of an awardable(issue, merge request or snippet).
    # @param [String] awardable_type The type of the awardable(can be 'issue', 'merge_request' or 'snippet')
    # @return [Array<Gitlab::ObjectifiedHash>]
    def award_emojis(project, awardable_id, awardable_type)
      get("/projects/#{url_encode project}/#{awardable_type}s/#{awardable_id}/award_emoji")
    end

    # Gets a list of all award emoji for a single note on an awardable(issue, merge request or snippet)
    #
    # @example
    #   Gitlab.note_award_emojis(1, 80, 'issue', 1)
    #   Gitlab.note_award_emojis(1, 60, 'merge_request', 1)
    #   Gitlab.note_award_emojis(1, 40, 'snippet', 1)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] awardable_id The ID of an awardable(issue, merge request or snippet).
    # @param [String] awardable_type The type of the awardable(can be 'issue', 'merge_request' or 'snippet')
    # @param [Integer] note_id The ID of a note.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def note_award_emojis(project, awardable_id, awardable_type, note_id)
      get("/projects/#{url_encode project}/#{awardable_type}s/#{awardable_id}/notes/#{note_id}/award_emoji")
    end

    # Gets a single award emoji for an awardable(issue, merge request or snippet)
    #
    # @example
    #   Gitlab.award_emoji(1, 80, 'issue', 4)
    #   Gitlab.award_emoji(1, 60, 'merge_request', 4)
    #   Gitlab.award_emoji(1, 40, 'snippet', 4)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] awardable_id The ID of an awardable(issue, merge request or snippet).
    # @param [String] awardable_type The type of the awardable(can be 'issue', 'merge_request' or 'snippet')
    # @param [Integer] award_id The ID of an award emoji.
    # @return [Gitlab::ObjectifiedHash]
    def award_emoji(project, awardable_id, awardable_type, award_id)
      get("/projects/#{url_encode project}/#{awardable_type}s/#{awardable_id}/award_emoji/#{award_id}")
    end

    # Gets a single award emoji from a single note on an awardable(issue, merge request or snippet)
    #
    # @example
    #   Gitlab.note_award_emoji(1, 80, 'issue', 1, 4)
    #   Gitlab.note_award_emoji(1, 60, 'merge_request', 1, 4)
    #   Gitlab.note_award_emoji(1, 40, 'snippet', 1, 4)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] awardable_id The ID of an awardable(issue, merge request or snippet).
    # @param [String] awardable_type The type of the awardable(can be 'issue', 'merge_request' or 'snippet')
    # @param [Integer] note_id The ID of a note.
    # @param [Integer] award_id The ID of an award emoji.
    # @return [Gitlab::ObjectifiedHash]
    def note_award_emoji(project, awardable_id, awardable_type, note_id, award_id)
      get("/projects/#{url_encode project}/#{awardable_type}s/#{awardable_id}/notes/#{note_id}/award_emoji/#{award_id}")
    end

    # Awards a new emoji to an awardable(issue, merge request or snippet)
    #
    # @example
    #   Gitlab.create_award_emoji(1, 80, 'issue', 'blowfish')
    #   Gitlab.create_award_emoji(1, 80, 'merge_request', 'blowfish')
    #   Gitlab.create_award_emoji(1, 80, 'snippet', 'blowfish')
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] awardable_id The ID of an awardable(issue, merge request or snippet).
    # @param [String] awardable_type The type of the awardable(can be 'issue', 'merge_request' or 'snippet')
    # @param [String] emoji_name The name of the emoji, without colons.
    # @return [Gitlab::ObjectifiedHash]
    def create_award_emoji(project, awardable_id, awardable_type, emoji_name)
      post("/projects/#{url_encode project}/#{awardable_type}s/#{awardable_id}/award_emoji", body: { name: emoji_name })
    end

    # Awards a new emoji to a note on an awardable(issue, merge request or snippet)
    #
    # @example
    #   Gitlab.create_note_award_emoji(1, 80, 'issue', 1, 'blowfish')
    #   Gitlab.create_note_award_emoji(1, 80, 'merge_request', 1, 'blowfish')
    #   Gitlab.create_note_award_emoji(1, 80, 'snippet', 1, 'blowfish')
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] awardable_id The ID of an awardable(issue, merge request or snippet).
    # @param [String] awardable_type The type of the awardable(can be 'issue', 'merge_request' or 'snippet')
    # @param [Integer] note_id The ID of a note.
    # @param [String] emoji_name The name of the emoji, without colons.
    # @return [Gitlab::ObjectifiedHash]
    def create_note_award_emoji(project, awardable_id, awardable_type, note_id, emoji_name)
      post("/projects/#{url_encode project}/#{awardable_type}s/#{awardable_id}/notes/#{note_id}/award_emoji", body: { name: emoji_name })
    end

    # Deletes a single award emoji from an awardable(issue, merge request or snippet)
    #
    # @example
    #   Gitlab.delete_award_emoji(1, 80, 'issue', 4)
    #   Gitlab.delete_award_emoji(1, 60, 'merge_request', 4)
    #   Gitlab.delete_award_emoji(1, 40, 'snippet', 4)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] awardable_id The ID of an awardable(issue, merge request or snippet).
    # @param [String] awardable_type The type of the awardable(can be 'issue', 'merge_request' or 'snippet')
    # @param [Integer] award_id The ID of an award emoji.
    # @return [void] This API call returns an empty response body.
    def delete_award_emoji(project, awardable_id, awardable_type, award_id)
      delete("/projects/#{url_encode project}/#{awardable_type}s/#{awardable_id}/award_emoji/#{award_id}")
    end

    # Deletes a single award emoji from a single note on an awardable(issue, merge request or snippet)
    #
    # @example
    #   Gitlab.delete_note_award_emoji(1, 80, 'issue', 1, 4)
    #   Gitlab.delete_note_award_emoji(1, 60, 'merge_request', 1, 4)
    #   Gitlab.delete_note_award_emoji(1, 40, 'snippet', 1, 4)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] awardable_id The ID of an awardable(issue, merge request or snippet).
    # @param [String] awardable_type The type of the awardable(can be 'issue', 'merge_request' or 'snippet')
    # @param [Integer] note_id The ID of a note.
    # @param [Integer] award_id The ID of an award emoji.
    # @return [void] This API call returns an empty response body.
    def delete_note_award_emoji(project, awardable_id, awardable_type, note_id, award_id)
      delete("/projects/#{url_encode project}/#{awardable_type}s/#{awardable_id}/notes/#{note_id}/award_emoji/#{award_id}")
    end
  end
end
