require 'spec_helper'

describe Gitlab::Client do
  describe ".issues" do
    context "with project ID passed" do
      before do
        stub_get("/projects/3/issues", "project_issues")
        @issues = Gitlab.issues(3)
      end

      it "should get the correct resource" do
        expect(a_get("/projects/3/issues")).to have_been_made
      end

      it "should return a paginated response of project's issues" do
        expect(@issues).to be_a Gitlab::PaginatedResponse
        expect(@issues.first.project_id).to eq(3)
      end
    end

    context 'with literal project ID passed' do
      before do
        stub_get("/projects/gitlab-org%2Fgitlab-ce/issues", "project_issues")
        @issues = Gitlab.issues('gitlab-org/gitlab-ce')
      end

      it "should get the correct resource" do
        expect(a_get("/projects/gitlab-org%2Fgitlab-ce/issues")).to have_been_made
      end

      it "should return a paginated response of project's issues" do
        expect(@issues).to be_a Gitlab::PaginatedResponse
        expect(@issues.first.project_id).to eq(3)
      end
    end

    context "without project ID passed" do
      before do
        stub_get("/issues", "issues")
        @issues = Gitlab.issues
      end

      it "should get the correct resource" do
        expect(a_get("/issues")).to have_been_made
      end

      it "should return a paginated response of user's issues" do
        expect(@issues).to be_a Gitlab::PaginatedResponse
        expect(@issues.first.closed).to be_falsey
        expect(@issues.first.author.name).to eq("John Smith")
      end
    end
  end

  describe ".issue" do
    before do
      stub_get("/projects/3/issues/33", "issue")
      @issue = Gitlab.issue(3, 33)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/issues/33")).to have_been_made
    end

    it "should return information about an issue" do
      expect(@issue.project_id).to eq(3)
      expect(@issue.assignee.name).to eq("Jack Smith")
    end
  end

  describe ".create_issue" do
    before do
      stub_post("/projects/3/issues", "issue")
      @issue = Gitlab.create_issue(3, 'title')
    end

    it "should get the correct resource" do
      expect(a_post("/projects/3/issues").
        with(body: { title: 'title' })).to have_been_made
    end

    it "should return information about a created issue" do
      expect(@issue.project_id).to eq(3)
      expect(@issue.assignee.name).to eq("Jack Smith")
    end
  end

  describe ".edit_issue" do
    before do
      stub_put("/projects/3/issues/33", "issue")
      @issue = Gitlab.edit_issue(3, 33, title: 'title')
    end

    it "should get the correct resource" do
      expect(a_put("/projects/3/issues/33").
        with(body: { title: 'title' })).to have_been_made
    end

    it "should return information about an edited issue" do
      expect(@issue.project_id).to eq(3)
      expect(@issue.assignee.name).to eq("Jack Smith")
    end
  end

  describe ".close_issue" do
    before do
      stub_put("/projects/3/issues/33", "issue")
      @issue = Gitlab.close_issue(3, 33)
    end

    it "should get the correct resource" do
      expect(a_put("/projects/3/issues/33").
        with(body: { state_event: 'close' })).to have_been_made
    end

    it "should return information about an closed issue" do
      expect(@issue.project_id).to eq(3)
      expect(@issue.assignee.name).to eq("Jack Smith")
    end
  end

  describe ".reopen_issue" do
    before do
      stub_put("/projects/3/issues/33", "issue")
      @issue = Gitlab.reopen_issue(3, 33)
    end

    it "should get the correct resource" do
      expect(a_put("/projects/3/issues/33").
        with(body: { state_event: 'reopen' })).to have_been_made
    end

    it "should return information about an reopened issue" do
      expect(@issue.project_id).to eq(3)
      expect(@issue.assignee.name).to eq("Jack Smith")
    end
  end

  describe ".subscribe_to_issue" do
    before do
      stub_post("/projects/3/issues/33/subscribe", "issue")
      @issue = Gitlab.subscribe_to_issue(3, 33)
    end

    it "should get the correct resource" do
      expect(a_post("/projects/3/issues/33/subscribe")).to have_been_made
    end

    it "should return information about the subscribed issue" do
      expect(@issue.project_id).to eq(3)
      expect(@issue.assignee.name).to eq("Jack Smith")
    end
  end

  describe ".unsubscribe_from_issue" do
    before do
      stub_post("/projects/3/issues/33/unsubscribe", "issue")
      @issue = Gitlab.unsubscribe_from_issue(3, 33)
    end

    it "should get the correct resource" do
      expect(a_post("/projects/3/issues/33/unsubscribe")).to have_been_made
    end

    it "should return information about the unsubscribed issue" do
      expect(@issue.project_id).to eq(3)
      expect(@issue.assignee.name).to eq("Jack Smith")
    end
  end

  describe ".delete_issue" do
    before do
      stub_delete("/projects/3/issues/33", "issue")
      @issue = Gitlab.delete_issue(3, 33)
    end

    it "should get the correct resource" do
      expect(a_delete("/projects/3/issues/33")).to have_been_made
    end

    it "should return information about a deleted issue" do
      expect(@issue.project_id).to eq(3)
      expect(@issue.id).to eq(33)
    end
  end
end
