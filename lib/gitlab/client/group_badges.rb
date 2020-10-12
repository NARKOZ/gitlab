# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to group badges.
  # @see https://docs.gitlab.com/ee/api/group_badges.html
  module GroupBadges
    # Gets a list of a groups badges.
    #
    # @example
    #   Gitlab.group_badges(5)
    #   Gitlab.group_badges(5, 'Coverage')
    #
    # @param [Integer, String] group(required) The ID or URL-encoded path of the group owned by the authenticated user.
    # @param [String] name(optional) Name of the badges to return (case-sensitive).
    # @return [Array<Gitlab::ObjectifiedHash>] List of all badges of a group
    def group_badges(group, name = nil)
      query = { name: name } if name
      get("/groups/#{url_encode group}/badges", query: query)
    end

    # Gets a badge of a group.
    #
    # @example
    #   Gitlab.group_badge(5, 42)
    #
    # @param [Integer, String] group(required) The ID or URL-encoded path of the group owned by the authenticated user.
    # @param [Integer] badge_id(required) The badge ID.
    # @return [Gitlab::ObjectifiedHash] Information about the requested badge
    def group_badge(group, badge_id)
      get("/groups/#{url_encode group}/badges/#{badge_id}")
    end

    # Adds a badge to a group.
    #
    # @example
    #   Gitlab.add_group_badge(5, { link_url: 'https://abc.com/gitlab/gitlab-ce/commits/master', image_url: 'https://shields.io/my/badge1' })
    #
    # @param [Integer, String] group(required) The ID or URL-encoded path of the group owned by the authenticated user.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :link_url(required) URL of the badge link
    # @option options [String] :image_url(required) URL of the badge image
    # @return [Gitlab::ObjectifiedHash] Information about the added group badge.
    def add_group_badge(group, options = {})
      post("/groups/#{url_encode group}/badges", body: options)
    end

    # Updates a badge of a group.
    #
    # @example
    #   Gitlab.edit_group_badge(5, 1, { link_url: 'https://abc.com/gitlab/gitlab-ce/commits/master', image_url: 'https://shields.io/my/badge1' })
    #
    # @param [Integer, String] group(required) The ID or URL-encoded path of the group owned by the authenticated user.
    # @param [Integer] badge_id(required) The badge ID.
    # @param [Hash] options A customizable set of options.
    # @option options [String] :link_url(optional) URL of the badge link
    # @option options [String] :image_url(optional) URL of the badge image
    # @return [Gitlab::ObjectifiedHash] Information about the updated group badge.
    def edit_group_badge(group, badge_id, options = {})
      put("/groups/#{url_encode group}/badges/#{badge_id}", body: options)
    end

    # Removes a badge from a group.
    #
    # @example
    #   Gitlab.remove_group_badge(5, 42)
    #
    # @param [Integer, String] group(required) The ID or URL-encoded path of the group owned by the authenticated user.
    # @param [Integer] badge_id(required) The badge ID.
    # @return [nil] This API call returns an empty response body.
    def remove_group_badge(group, badge_id)
      delete("/groups/#{url_encode group}/badges/#{badge_id}")
    end

    # Preview a badge from a group.
    #
    # @example
    #   Gitlab.preview_group_badge(3, 'https://abc.com/gitlab/gitlab-ce/commits/master', 'https://shields.io/my/badge1')
    #
    # @param [Integer, String] group(required) The ID or URL-encoded path of the group owned by the authenticated user.
    # @param [String] :link_url(required) URL of the badge link
    # @param [String] :image_url(required) URL of the badge image
    # @return [Gitlab::ObjectifiedHash] Returns how the link_url and image_url final URLs would be after resolving the placeholder interpolation.
    def preview_group_badge(group, link_url, image_url)
      query = { link_url: link_url, image_url: image_url }
      get("/groups/#{url_encode group}/badges/render", query: query)
    end
  end
end
