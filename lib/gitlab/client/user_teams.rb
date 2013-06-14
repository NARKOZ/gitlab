class Gitlab::Client
  # Defines methods related to users.
  module UserTeams
    # Gets a list of users_teams.
    #
    # @example
    #   Gitlab.user_teams
    #
    # @return [Array<Gitlab::ObjectifiedHash>]
    def user_teams(options={})
      get("/user_teams")
    end

    # Gets information about a user team.
    #
    # @example
    #   Gitlab.user_team(2)
    #
    # @param  [Integer] (required) The ID of a user_team.
    # @return [Gitlab::ObjectifiedHash]
    def user_team(team_id)
      get("/user_teams/#{team_id}")
    end

    # Creates new user team owned by user. Available only for admins.
    # Requires authentication from an admin account.
    #
    # @param  [String] (required) - new user team name
    # @param  [String] (required) - new user team internal name
    # @return [Gitlab::ObjectifiedHash] Information about created user.
    def create_user_team(name, path)
      post("/user_teams", :body => {:name => name, :path => path})
    end

    # Get a list of project team members. If user id is specified get a specific user
    #
    # @example
    #   Gitlab.user_team_members(1)
    #   Gitlab.user_team_members(1,3)
    #
    # @param  [Integer] (required) - The ID of a user_team
    # @param  [Integer] (optional) - The ID of a user
    # @return [Gitlab::ObjectifiedHash]
    def user_team_members(id, user_id = nil)
      user_id.to_i.zero? ? get("/user_teams/#{id}/members") : get("/user_teams/#{id}/members/#{user_id}")
    end

    # Adds a user to user team.
    #
    # @example
    #   Gitlab.add_user_team_member(1, 2, 40)
    #
    # @param  [Integer] (required) The team id to add a member to
    # @param  [Integer] (required) The user id of the user to add to the team
    # @param  [Integer] (required) access_level Project access level
    # @return [Array<Gitlab::ObjectifiedHash>] Information about added team member.
    def add_user_team_member(team_id, user_id, access_level)
      post("/user_teams/#{team_id}/members", :body => {:user_id => user_id, :access_level => access_level})
    end

    # Removes user from user team.
    #
    # @example
    #   Gitlab.remove_user_team_member(1, 2)
    #
    # @param  [Integer] (required) The team ID.
    # @param  [Integer] (required) id The ID of a user.
    # @return [Array<Gitlab::ObjectifiedHash>] Information about removed team member.
    def remove_user_team_member(team_id, user_id)
      delete("/user_teams/#{team_id}/members/#{user_id}")
    end

    #  Get a list of user team projects. If project_id is specified gets the project specified
    #
    # @example
    #   Gitlab.user_teams_projects(1)
    #   Gitlab.user_teams_projects(1,2)
    #
    # @param [Integer] (required) - The ID of a user_team
    # @param [Integer] (optional - The ID of a project
    # @return [Array<Gitlab::ObjectifiedHash>]
    def user_teams_projects(team_id, project_id = nil)
      project_id.to_i.zero? ? get("/user_teams/#{team_id}/projects") : get("/user_teams/#{team_id}/projects/#{project_id}")
    end

    # Add user team project
    # Adds a project to a user team.
    #
    # @example
    #   Gitlab.user_teams.add_team_project(1, 2, 40)
    #
    # @param  [Integer] (required) The ID of a user team
    # @param  [Integer] (required) The ID of a project to add
    # @param  [Integer] (required) - Maximum project access level
    # @return [Array<Gitlab::ObjectifiedHash>] Information about added team project.
    def add_team_project(team_id, project_id, access_level)
      post("/user_teams/#{team_id}/projects", :body => {:project_id => project_id, :greatest_access_level => access_level})
    end

    # Remove user team project
    # Removes project from user team.
    #
    # @example
    #   Gitlab.user_teams.remove_team_project(1, 2)
    #
    # @param  [Integer] (required) The ID of a user team
    # @param  [Integer] (required)   The ID of a team project
    # @return [Array<Gitlab::ObjectifiedHash>] Information about removed team project.
    def remove_team_project(team_id, project_id)
      delete("/user_teams/#{team_id}/projects/#{project_id}")
    end

  end


end
