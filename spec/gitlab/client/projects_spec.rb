require 'spec_helper'

describe Gitlab::Client do
  describe ".projects" do
    before do
      stub_get("/projects", "projects")
      @projects = Gitlab.projects
    end

    it "should get the correct resource" do
      a_get("/projects").should have_been_made
    end

    it "should return an array of projects" do
      @projects.should be_an Array
      @projects.first.name.should == "Brute"
      @projects.first.owner.name.should == "John Smith"
    end
  end

  describe ".project" do
    before do
      stub_get("/projects/3", "project")
      @project = Gitlab.project(3)
    end

    it "should get the correct resource" do
      a_get("/projects/3").should have_been_made
    end

    it "should return information about a project" do
      @project.name.should == "Gitlab"
      @project.owner.name.should == "John Smith"
    end
  end

  describe ".create_project" do
    before do
      stub_post("/projects", "project")
      @project = Gitlab.create_project('Gitlab')
    end

    it "should get the correct resource" do
      a_post("/projects").should have_been_made
    end

    it "should return information about a created project" do
      @project.name.should == "Gitlab"
      @project.owner.name.should == "John Smith"
    end
  end

  describe ".create_project for user" do
    before do
      stub_post("/users", "user")
      @owner = Gitlab.create_user("john@example.com", "pass", {name: 'John Owner'})
      stub_post("/projects/user/#{@owner.id}", "project_for_user")
      @project = Gitlab.create_project('Brute', {:user_id => @owner.id})
    end

    it "should return information about a created project" do
      @project.name.should == "Brute"
      @project.owner.name.should == "John Owner"
    end
  end

  describe ".team_members" do
    before do
      stub_get("/projects/3/members", "team_members")
      @team_members = Gitlab.team_members(3)
    end

    it "should get the correct resource" do
      a_get("/projects/3/members").should have_been_made
    end

    it "should return an array of team members" do
      @team_members.should be_an Array
      @team_members.first.name.should == "John Smith"
    end
  end

  describe ".team_member" do
    before do
      stub_get("/projects/3/members/1", "team_member")
      @team_member = Gitlab.team_member(3, 1)
    end

    it "should get the correct resource" do
      a_get("/projects/3/members/1").should have_been_made
    end

    it "should return information about a team member" do
      @team_member.name.should == "John Smith"
    end
  end

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

  describe ".project_hooks" do
    before do
      stub_get("/projects/1/hooks", "project_hooks")
      @hooks = Gitlab.project_hooks(1)
    end

    it "should get the correct resource" do
      a_get("/projects/1/hooks").should have_been_made
    end

    it "should return an array of hooks" do
      @hooks.should be_an Array
      @hooks.first.url.should == "https://api.example.net/v1/webhooks/ci"
    end
  end

  describe ".project_hook" do
    before do
      stub_get("/projects/1/hooks/1", "project_hook")
      @hook = Gitlab.project_hook(1, 1)
    end

    it "should get the correct resource" do
      a_get("/projects/1/hooks/1").should have_been_made
    end

    it "should return information about a hook" do
      @hook.url.should == "https://api.example.net/v1/webhooks/ci"
    end
  end

  describe ".add_project_hook" do
    context "without specified events" do
      before do
        stub_post("/projects/1/hooks", "project_hook")
        @hook = Gitlab.add_project_hook(1, "https://api.example.net/v1/webhooks/ci")
      end

      it "should get the correct resource" do
        body = {:url => "https://api.example.net/v1/webhooks/ci"}
        a_post("/projects/1/hooks").with(:body => body).should have_been_made
      end

      it "should return information about an added hook" do
        @hook.url.should == "https://api.example.net/v1/webhooks/ci"
      end
    end

    context "with specified events" do
      before do
        stub_post("/projects/1/hooks", "project_hook")
        @hook = Gitlab.add_project_hook(1, "https://api.example.net/v1/webhooks/ci", push_events: true, merge_requests_events: true)
      end

      it "should get the correct resource" do
        body = {:url => "https://api.example.net/v1/webhooks/ci", push_events: "true", merge_requests_events: "true"}
        a_post("/projects/1/hooks").with(:body => body).should have_been_made
      end

      it "should return information about an added hook" do
        @hook.url.should == "https://api.example.net/v1/webhooks/ci"
      end
    end
  end

  describe ".edit_project_hook" do
    before do
      stub_put("/projects/1/hooks/1", "project_hook")
      @hook = Gitlab.edit_project_hook(1, 1, "https://api.example.net/v1/webhooks/ci")
    end

    it "should get the correct resource" do
      body = {:url => "https://api.example.net/v1/webhooks/ci"}
      a_put("/projects/1/hooks/1").with(:body => body).should have_been_made
    end

    it "should return information about an edited hook" do
      @hook.url.should == "https://api.example.net/v1/webhooks/ci"
    end
  end

  describe ".delete_project_hook" do
    before do
      stub_delete("/projects/1/hooks/1", "project_hook")
      @hook = Gitlab.delete_project_hook(1, 1)
    end

    it "should get the correct resource" do
      a_delete("/projects/1/hooks/1").should have_been_made
    end

    it "should return information about a deleted hook" do
      @hook.url.should == "https://api.example.net/v1/webhooks/ci"
    end
  end

  describe ".make_forked_from" do
    before do
      stub_post("/projects/42/fork/24", "project_fork_link")
      @forked_project_link = Gitlab.make_forked_from(42, 24)
    end

    it "should get the correct resource" do
      a_post("/projects/42/fork/24").should have_been_made
    end

    it "should return information about a forked project" do
      @forked_project_link.forked_from_project_id.should == 24
      @forked_project_link.forked_to_project_id.should == 42
    end
  end

  describe ".remove_forked" do
    before do
      stub_delete("/projects/42/fork", "project_fork_link")
      @forked_project_link = Gitlab.remove_forked(42)
    end

    it "should be sent to correct resource" do
      a_delete("/projects/42/fork").should have_been_made
    end

    it "should return information about an unforked project" do
      @forked_project_link.forked_to_project_id.should == 42
    end
  end

  describe ".deploy_keys" do
    before do
      stub_get("/projects/42/keys", "project_keys")
      @deploy_keys = Gitlab.deploy_keys(42)
    end

    it "should get the correct resource" do
      a_get("/projects/42/keys").should have_been_made
    end

    it "should return project deploy keys" do
      @deploy_keys.should be_an Array
      @deploy_keys.first.id.should eq 2
      @deploy_keys.first.title.should eq "Key Title"
      @deploy_keys.first.key.should match(/ssh-rsa/)
    end
  end

  describe ".deploy_key" do
    before do
      stub_get("/projects/42/keys/2", "project_key")
      @deploy_key = Gitlab.deploy_key(42, 2)
    end

    it "should get the correct resource" do
      a_get("/projects/42/keys/2").should have_been_made
    end

    it "should return project deploy key" do
      @deploy_key.id.should eq 2
      @deploy_key.title.should eq "Key Title"
      @deploy_key.key.should match(/ssh-rsa/)
    end
  end

  describe ".delete_deploy_key" do
    before do
      stub_delete("/projects/42/keys/2", "project_delete_key")
      @deploy_key = Gitlab.delete_deploy_key(42, 2)
    end

    it "should get the correct resource" do
      a_delete("/projects/42/keys/2").should have_been_made
    end

    it "should return information about a deleted key" do
      @deploy_key.id.should == 2
    end
  end
end
