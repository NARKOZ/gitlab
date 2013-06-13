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
      body = {:name => "Foo", :path=> "foo"}
      a_post("/user_teams").with(:body => body).should have_been_made
    end

    it "should return information about a created user" do
      @user_team.name.should == "Foo"
    end
  end


  describe ".team_members" do
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

  describe ".team_member" do
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
=begin
  describe ".add_team_member" do
    before do
      stub_post("/projects/3/members", "team_member")
      @team_member = Gitlab.add_team_member(3, 1, 40)
    end

    it "should get the correct resource" do
      a_post("/projects/3/members").
          with(:body => {:user_id => '1', :access_level => '40'}).should have_been_made
    end

    it "should return information about an added team member" do
      @team_member.name.should == "John Smith"
    end
  end

  describe ".edit_team_member" do
    before do
      stub_put("/projects/3/members/1", "team_member")
      @team_member = Gitlab.edit_team_member(3, 1, 40)
    end

    it "should get the correct resource" do
      a_put("/projects/3/members/1").
          with(:body => {:access_level => '40'}).should have_been_made
    end

    it "should return information about an edited team member" do
      @team_member.name.should == "John Smith"
    end
  end

  describe ".remove_team_member" do
    before do
      stub_delete("/projects/3/members/1", "team_member")
      @team_member = Gitlab.remove_team_member(3, 1)
    end

    it "should get the correct resource" do
      a_delete("/projects/3/members/1").should have_been_made
    end

    it "should return information about a removed team member" do
      @team_member.name.should == "John Smith"
    end
  end
=end
end
