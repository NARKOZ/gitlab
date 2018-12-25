# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to project badges.
  # @see https://docs.gitlab.com/ee/api/project_badges.html
  module ProjectBadges
    # Gets a list of a projects badges and its group badges.
    #
    # @example
    #   Gitlab.project_badges(5)
    #
    # @param [Integer, String] project The ID or name of a project.
    # @return [Array<Gitlab::ObjectifiedHash>] List of all badges of a project
    def project_badges(project)
      get("/projects/#{url_encode project}/badges")
    end

    # Gets a badge of a project.
    #
    # @example
    #   Gitlab.project_badge(5, 42)
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [Integer] badge_id The badge ID.
    # @return [Gitlab::ObjectifiedHash] Information about the requested badge
    def project_badge(project, badge_id)
      get("/projects/#{url_encode project}/badges/#{badge_id}")
    end

    # Adds a badge to a project.
    #
    # @example
    #   Gitlab.add_project_badge(5, { link_url: 'https://abc.com/gitlab/gitlab-ce/commits/master', image_url: 'https://shields.io/my/badge1' })
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :link_url(required) URL of the badge link
    # @option options [String] :image_url(required) URL of the badge image
    # @return [Gitlab::ObjectifiedHash] Information about the added project badge.
    def add_project_badge(project, options = {})
      post("/projects/#{url_encode project}/badges", body: options)
    end

    # Updates a badge of a project..
    #
    # @example
    #   Gitlab.edit_project_badge(5, 1, { link_url: 'https://abc.com/gitlab/gitlab-ce/commits/master', image_url: 'https://shields.io/my/badge1' })
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [Integer] badge_id The badge ID.
    # @param [Hash] options A customizable set of options.
    # @option options [String] :link_url(optional) URL of the badge link
    # @option options [String] :image_url(optional) URL of the badge image
    # @return [Gitlab::ObjectifiedHash] Information about the updated project badge.
    def edit_project_badge(project, badge_id, options = {})
      put("/projects/#{url_encode project}/badges/#{badge_id}", body: options)
    end

    # Removes a badge from a project. Only projects badges will be removed by using this endpoint.
    #
    # @example
    #   Gitlab.remove_project_badge(5, 42)
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [Integer] badge_id The badge ID.
    # @return [nil] This API call returns an empty response body.
    def remove_project_badge(project, badge_id)
      delete("/projects/#{url_encode project}/badges/#{badge_id}")
    end

    # Preview a badge from a project.
    #
    # @example
    #   Gitlab.preview_project_badge(3, 'https://abc.com/gitlab/gitlab-ce/commits/master', 'https://shields.io/my/badge1')
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [String] :link_url URL of the badge link
    # @param [String] :image_url URL of the badge image
    # @return [Gitlab::ObjectifiedHash] Returns how the link_url and image_url final URLs would be after resolving the placeholder interpolation.
    def preview_project_badge(project, link_url, image_url)
      query = { link_url: link_url, image_url: image_url }
      get("/projects/#{url_encode project}/badges/render", query: query)
    end
  end
end
