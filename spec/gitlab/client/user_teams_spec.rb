require 'spec_helper'

describe Gitlab::Client do
  describe ".user_teams" do
    before do
      stub_get("/user_teams/1", "user_team")
      @user_team = Gitlab.user_team(1)
    end

    it "should get the correct resource" do
      a_get("/user_teams/1").should have_been_made
    end

    it "should return information about a user_team" do
      @user_team.name.should == "Foo"
    end
  end

  describe ".user_team" do
    before do
      stub_get("/user_teams", "user_teams")
      @user_teams = Gitlab.user_teams
    end

    it "should get the correct resource" do
      a_get("/user_teams").should have_been_made
    end

    it "should return an array of user_teams" do
      @user_teams.should be_an Array
      @user_teams.first.name.should == "Foo"
    end
  end


  describe ".create_user_team" do
    before do
      stub_post("/user_teams", "user_team")
      @user_team = Gitlab.create_user_team("Foo", "foo")
    end

    it "should get the correct resource" do
      body = {:name => "Foo", :path => "foo"}
      a_post("/user_teams").with(:body => body).should have_been_made
    end

    it "should return information about a created user" do
      @user_team.name.should == "Foo"
    end
  end


  describe ".user_team_members" do
    context "when with no specific member" do
      before do
        stub_get("/user_teams/3/members", "user_team_members")
        @team_members = Gitlab.user_team_members(3)
      end

      it "should get the correct resource" do
        a_get("/user_teams/3/members").should have_been_made
      end

      it "should return an array of team members" do
        @team_members.should be_an Array
        @team_members.first.name.should == "John Smith"
      end
    end
    context "when passed a particular member" do
      before do
        stub_get("/user_teams/3/members/1", "user_team_member")
        @team_members = Gitlab.user_team_members(3, 1)
      end

      it "should get the correct resource" do
        a_get("/user_teams/3/members/1").should have_been_made
      end

      it "should return information about a team member" do
        @team_members.name.should == "John Smith"
      end
    end
  end

  describe ".add_user_team_member" do
    before do
      stub_post("/user_teams/3/members", "user_team_member")
      @team_member = Gitlab.add_user_team_member(3, 1, 40)
    end

    it "should get the correct resource" do
      a_post("/user_teams/3/members").
          with(:body => {:user_id => '1', :access_level => '40'}).should have_been_made
    end

    it "should return information about an added team member" do
      @team_member.name.should == "John Smith"
    end
  end

  describe ".remove_user_team_member" do
    before do
      stub_delete("/user_teams/3/members/1", "user_team_member")
      @team_member = Gitlab.remove_user_team_member(3, 1)
    end

    it "should get the correct resource" do
      a_delete("/user_teams/3/members/1").should have_been_made
    end

    it "should return information about a removed team member" do
      @team_member.name.should == "John Smith"
    end
  end


  describe ".user_teams_projects" do
    context 'when called with out project id' do
      before do
        stub_get("/user_teams/3/projects", "user_team_projects")
        @team_projects = Gitlab.user_teams_projects(3)
      end

      it "should get the correct resource" do
        a_get("/user_teams/3/projects").should have_been_made
      end

      it "should return information about team projects" do
        @team_projects[0].name.should == "example_project"
      end
    end

    context 'when called with project id' do
      before do
        stub_get("/user_teams/3/projects/1", "user_team_project")
        @team_project = Gitlab.user_teams_projects(3, 1)
      end

      it "should get the correct resource" do
        a_get("/user_teams/3/projects/1").should have_been_made
      end

      it "should return information about a team project" do
        @team_project.name.should == "example_project"
      end
    end
  end

  describe ".add_team_project" do
    before do
      stub_post("/user_teams/3/projects", "user_team_project")
      @team_project = Gitlab.add_team_project(3, 1, 40)
    end

    it "should get the correct resource" do
      a_post("/user_teams/3/projects").
          with(:body => {:project_id => '1', :access_level => '40'}).should have_been_made
    end

    it "should return information about an added team project" do
      @team_project.name.should == "example_project"
    end
  end


  describe ".remove_team_project" do
    before do
      stub_delete("/user_teams/3/projects/1", "user_team_project")
      @team_project = Gitlab.remove_team_project(3, 1)
    end

    it "should get the correct resource" do
      a_delete("/user_teams/3/projects/1").should have_been_made
    end

    it "should return information about a removed team project" do
      @team_project.name.should == "example_project"
    end
  end
end
