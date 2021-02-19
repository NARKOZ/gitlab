# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to groups invitations.
  # @see https://docs.gitlab.com/ee/api/invitations.html
  module GroupInvites
    # Invites user(s) through email to group.
    #
    # @example
    #   Gitlab.group_invites(1, ['example@example.com'], 30)
    #
    # @param  [Integer] id The group id to invite the member to
    # @param  [Array] emails The emails of the people to invite.
    # @param  [Integer] access_level The Group access level.

    # @return [Gitlab::ObjectifiedHash] Information about added team member.
    def create_group_invites(id, emails, access_level, expires_at = nil)
      body = { email: emails, access_level: access_level }
      body[:expires_at] if expires_at
      post("/groups/#{url_encode id}/invitations", body: body)
    end
  end
end
