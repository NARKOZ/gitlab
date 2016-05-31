require 'spec_helper'

describe Gitlab::Client do
  it { should respond_to :search_projects }

  describe ".projects" do
    before do
      stub_get("/projects", "projects")
      @projects = Gitlab.projects
    end

    it "should get the correct resource" do
      expect(a_get("/projects")).to have_been_made
    end

    it "should return a paginated response of projects" do
      expect(@projects).to be_a Gitlab::PaginatedResponse
      expect(@projects.first.name).to eq("Brute")
      expect(@projects.first.owner.name).to eq("John Smith")
    end
  end

  describe ".project_search" do
    before do
      stub_get("/projects/search/Gitlab", "project_search")
      @project_search = Gitlab.project_search("Gitlab")
    end

    it "should get the correct resource" do
      expect(a_get("/projects/search/Gitlab")).to have_been_made
    end

    it "should return a paginated response of projects found" do
      expect(@project_search).to be_a Gitlab::PaginatedResponse
      expect(@project_search.first.name).to eq("Gitlab")
      expect(@project_search.first.owner.name).to eq("John Smith")
    end
  end

  describe ".project" do
    before do
      stub_get("/projects/3", "project")
      @project = Gitlab.project(3)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3")).to have_been_made
    end

    it "should return information about a project" do
      expect(@project.name).to eq("Gitlab")
      expect(@project.owner.name).to eq("John Smith")
    end
  end

  describe ".project_events" do
    before do
      stub_get("/projects/2/events", "project_events")
      @events = Gitlab.project_events(2)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/2/events")).to have_been_made
    end

    it "should return a paginated response of events" do
      expect(@events).to be_a Gitlab::PaginatedResponse
      expect(@events.size).to eq(2)
    end

    it "should return the action name of the event" do
      expect(@events.first.action_name).to eq("opened")
    end
  end

  describe ".create_project" do
    before do
      stub_post("/projects", "project")
      @project = Gitlab.create_project('Gitlab')
    end

    it "should get the correct resource" do
      expect(a_post("/projects")).to have_been_made
    end

    it "should return information about a created project" do
      expect(@project.name).to eq("Gitlab")
      expect(@project.owner.name).to eq("John Smith")
    end
  end

  describe ".create_project for user" do
    before do
      stub_post("/users", "user")
      @owner = Gitlab.create_user("john@example.com", "pass", name: 'John Owner')
      stub_post("/projects/user/#{@owner.id}", "project_for_user")
      @project = Gitlab.create_project('Brute', user_id: @owner.id)
    end

    it "should return information about a created project" do
      expect(@project.name).to eq("Brute")
      expect(@project.owner.name).to eq("John Owner")
    end
  end

  describe ".delete_project" do
    before do
      stub_delete("/projects/Gitlab", "project")
      @project = Gitlab.delete_project('Gitlab')
    end

    it "should get the correct resource" do
      expect(a_delete("/projects/Gitlab")).to have_been_made
    end

    it "should return information about a deleted project" do
      expect(@project.name).to eq("Gitlab")
      expect(@project.owner.name).to eq("John Smith")
    end
  end

  describe ".create_fork" do
    context "without sudo option" do
      before do
        stub_post("/projects/fork/3", "project_fork")
        @project = Gitlab.create_fork(3)
      end

      it "should post to the correct resource" do
        expect(a_post("/projects/fork/3")).to have_been_made
      end

      it "should return information about the forked project" do
        expect(@project.forked_from_project.id).to eq(3)
        expect(@project.id).to eq(20)
      end
    end

    context "with the sudo option" do
      before do
        stub_post("/projects/fork/3", "project_forked_for_user")
        @sudoed_username = 'jack.smith'
        @project = Gitlab.create_fork(3, sudo: @sudoed_username)
      end

      it "should post to the correct resource" do
        expect(a_post("/projects/fork/3")).to have_been_made
      end

      it "should return information about the forked project" do
        expect(@project.forked_from_project.id).to eq(3)
        expect(@project.id).to eq(20)
        expect(@project.owner.username).to eq(@sudoed_username)
      end
    end
  end

  describe ".team_members" do
    before do
      stub_get("/projects/3/members", "team_members")
      @team_members = Gitlab.team_members(3)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/members")).to have_been_made
    end

    it "should return a paginated response of team members" do
      expect(@team_members).to be_a Gitlab::PaginatedResponse
      expect(@team_members.first.name).to eq("John Smith")
    end
  end

  describe ".team_member" do
    before do
      stub_get("/projects/3/members/1", "team_member")
      @team_member = Gitlab.team_member(3, 1)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/members/1")).to have_been_made
    end

    it "should return information about a team member" do
      expect(@team_member.name).to eq("John Smith")
    end
  end

  describe ".add_team_member" do
    before do
      stub_post("/projects/3/members", "team_member")
      @team_member = Gitlab.add_team_member(3, 1, 40)
    end

    it "should get the correct resource" do
      expect(a_post("/projects/3/members").
          with(body: { user_id: '1', access_level: '40' })).to have_been_made
    end

    it "should return information about an added team member" do
      expect(@team_member.name).to eq("John Smith")
    end
  end

  describe ".edit_team_member" do
    before do
      stub_put("/projects/3/members/1", "team_member")
      @team_member = Gitlab.edit_team_member(3, 1, 40)
    end

    it "should get the correct resource" do
      expect(a_put("/projects/3/members/1").
          with(body: { access_level: '40' })).to have_been_made
    end

    it "should return information about an edited team member" do
      expect(@team_member.name).to eq("John Smith")
    end
  end

  describe ".remove_team_member" do
    before do
      stub_delete("/projects/3/members/1", "team_member")
      @team_member = Gitlab.remove_team_member(3, 1)
    end

    it "should get the correct resource" do
      expect(a_delete("/projects/3/members/1")).to have_been_made
    end

    it "should return information about a removed team member" do
      expect(@team_member.name).to eq("John Smith")
    end
  end

  describe ".project_hooks" do
    before do
      stub_get("/projects/1/hooks", "project_hooks")
      @hooks = Gitlab.project_hooks(1)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/1/hooks")).to have_been_made
    end

    it "should return a paginated response of hooks" do
      expect(@hooks).to be_a Gitlab::PaginatedResponse
      expect(@hooks.first.url).to eq("https://api.example.net/v1/webhooks/ci")
    end
  end

  describe ".project_hook" do
    before do
      stub_get("/projects/1/hooks/1", "project_hook")
      @hook = Gitlab.project_hook(1, 1)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/1/hooks/1")).to have_been_made
    end

    it "should return information about a hook" do
      expect(@hook.url).to eq("https://api.example.net/v1/webhooks/ci")
    end
  end

  describe ".add_project_hook" do
    context "without specified events" do
      before do
        stub_post("/projects/1/hooks", "project_hook")
        @hook = Gitlab.add_project_hook(1, "https://api.example.net/v1/webhooks/ci")
      end

      it "should get the correct resource" do
        body = { url: "https://api.example.net/v1/webhooks/ci" }
        expect(a_post("/projects/1/hooks").with(body: body)).to have_been_made
      end

      it "should return information about an added hook" do
        expect(@hook.url).to eq("https://api.example.net/v1/webhooks/ci")
      end
    end

    context "with specified events" do
      before do
        stub_post("/projects/1/hooks", "project_hook")
        @hook = Gitlab.add_project_hook(1, "https://api.example.net/v1/webhooks/ci", push_events: true, merge_requests_events: true)
      end

      it "should get the correct resource" do
        body = { url: "https://api.example.net/v1/webhooks/ci", push_events: "true", merge_requests_events: "true" }
        expect(a_post("/projects/1/hooks").with(body: body)).to have_been_made
      end

      it "should return information about an added hook" do
        expect(@hook.url).to eq("https://api.example.net/v1/webhooks/ci")
      end
    end
  end

  describe ".edit_project_hook" do
    before do
      stub_put("/projects/1/hooks/1", "project_hook")
      @hook = Gitlab.edit_project_hook(1, 1, "https://api.example.net/v1/webhooks/ci")
    end

    it "should get the correct resource" do
      body = { url: "https://api.example.net/v1/webhooks/ci" }
      expect(a_put("/projects/1/hooks/1").with(body: body)).to have_been_made
    end

    it "should return information about an edited hook" do
      expect(@hook.url).to eq("https://api.example.net/v1/webhooks/ci")
    end
  end

  describe ".edit_project" do
    before do
      stub_put("/projects/3", "project_edit").with(query: { name: "Gitlab-edit" })
      @edited_project = Gitlab.edit_project(3, name: "Gitlab-edit")
    end

    it "should get the correct resource" do
      expect(a_put("/projects/3").with(query: { name: "Gitlab-edit" })).to have_been_made
    end

    it "should return information about an edited project" do
      expect(@edited_project.name).to eq("Gitlab-edit")
    end
  end

  describe ".delete_project_hook" do
    context "when empty response" do
      before do
        stub_request(:delete, "#{Gitlab.endpoint}/projects/1/hooks/1").
          with(headers: { 'PRIVATE-TOKEN' => Gitlab.private_token }).
          to_return(body: '')
        @hook = Gitlab.delete_project_hook(1, 1)
      end

      it "should get the correct resource" do
        expect(a_delete("/projects/1/hooks/1")).to have_been_made
      end

      it "should return false" do
        expect(@hook).to be(false)
      end
    end

    context "when JSON response" do
      before do
        stub_delete("/projects/1/hooks/1", "project_hook")
        @hook = Gitlab.delete_project_hook(1, 1)
      end

      it "should get the correct resource" do
        expect(a_delete("/projects/1/hooks/1")).to have_been_made
      end

      it "should return information about a deleted hook" do
        expect(@hook.url).to eq("https://api.example.net/v1/webhooks/ci")
      end
    end
  end

  describe ".git_hook" do
    before do
      stub_get("/projects/1/git_hook", "git_hook")
      @git_hook = Gitlab.git_hook(1)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/1/git_hook")).to have_been_made
    end

    it "should return information about a git hook" do
      expect(@git_hook.commit_message_regex).to eq("\\b[A-Z]{3}-[0-9]+\\b")
    end
  end

  describe ".add_git_hook" do
    before do
      stub_post("/projects/1/git_hook", "git_hook")
      @git_hook = Gitlab.add_git_hook(1, { deny_delete_tag: false, commit_message_regex: "\\b[A-Z]{3}-[0-9]+\\b" })
    end

    it "should get the correct resource" do
      expect(a_post("/projects/1/git_hook")).to have_been_made
    end

    it "should return information about an added git hook" do
      expect(@git_hook.commit_message_regex).to eq("\\b[A-Z]{3}-[0-9]+\\b")
    end
  end

  describe ".edit_git_hook" do
    before do
      stub_put("/projects/1/git_hook", "git_hook")
      @git_hook = Gitlab.edit_git_hook(1, { deny_delete_tag: false, commit_message_regex: "\\b[A-Z]{3}-[0-9]+\\b" })
    end

    it "should get the correct resource" do
      expect(a_put("/projects/1/git_hook")).to have_been_made
    end

    it "should return information about an edited git hook" do
      expect(@git_hook.commit_message_regex).to eq("\\b[A-Z]{3}-[0-9]+\\b")
    end
  end

  describe ".delete_git_hook" do
    context "when empty response" do
      before do
        stub_request(:delete, "#{Gitlab.endpoint}/projects/1/git_hook").
          with(headers: { 'PRIVATE-TOKEN' => Gitlab.private_token }).
          to_return(body: '')
        @git_hook = Gitlab.delete_git_hook(1)
      end

      it "should get the correct resource" do
        expect(a_delete("/projects/1/git_hook")).to have_been_made
      end

      it "should return false" do
        expect(@git_hook).to be(false)
      end
    end

    context "when JSON response" do
      before do
        stub_delete("/projects/1/git_hook", "git_hook")
        @git_hook = Gitlab.delete_git_hook(1)
      end

      it "should get the correct resource" do
        expect(a_delete("/projects/1/git_hook")).to have_been_made
      end

      it "should return information about a deleted git hook" do
        expect(@git_hook.commit_message_regex).to eq("\\b[A-Z]{3}-[0-9]+\\b")
      end
    end
  end

  describe ".make_forked_from" do
    before do
      stub_post("/projects/42/fork/24", "project_fork_link")
      @forked_project_link = Gitlab.make_forked_from(42, 24)
    end

    it "should get the correct resource" do
      expect(a_post("/projects/42/fork/24")).to have_been_made
    end

    it "should return information about a forked project" do
      expect(@forked_project_link.forked_from_project_id).to eq(24)
      expect(@forked_project_link.forked_to_project_id).to eq(42)
    end
  end

  describe ".remove_forked" do
    before do
      stub_delete("/projects/42/fork", "project_fork_link")
      @forked_project_link = Gitlab.remove_forked(42)
    end

    it "should be sent to correct resource" do
      expect(a_delete("/projects/42/fork")).to have_been_made
    end

    it "should return information about an unforked project" do
      expect(@forked_project_link.forked_to_project_id).to eq(42)
    end
  end

  describe ".deploy_keys" do
    before do
      stub_get("/projects/42/keys", "project_keys")
      @deploy_keys = Gitlab.deploy_keys(42)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/42/keys")).to have_been_made
    end

    it "should return project deploy keys" do
      expect(@deploy_keys).to be_a Gitlab::PaginatedResponse
      expect(@deploy_keys.first.id).to eq 2
      expect(@deploy_keys.first.title).to eq "Key Title"
      expect(@deploy_keys.first.key).to match(/ssh-rsa/)
    end
  end

  describe ".deploy_key" do
    before do
      stub_get("/projects/42/keys/2", "project_key")
      @deploy_key = Gitlab.deploy_key(42, 2)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/42/keys/2")).to have_been_made
    end

    it "should return project deploy key" do
      expect(@deploy_key.id).to eq 2
      expect(@deploy_key.title).to eq "Key Title"
      expect(@deploy_key.key).to match(/ssh-rsa/)
    end
  end

  describe ".delete_deploy_key" do
    before do
      stub_delete("/projects/42/keys/2", "project_key")
      @deploy_key = Gitlab.delete_deploy_key(42, 2)
    end

    it "should get the correct resource" do
      expect(a_delete("/projects/42/keys/2")).to have_been_made
    end

    it "should return information about a deleted key" do
      expect(@deploy_key.id).to eq(2)
    end
  end
end
