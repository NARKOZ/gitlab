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

      it "should return an array of project's issues" do
        expect(@issues).to be_an Array
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

      it "should return an array of user's issues" do
        expect(@issues).to be_an Array
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
        with(:body => {:title => 'title'})).to have_been_made
    end

    it "should return information about a created issue" do
      expect(@issue.project_id).to eq(3)
      expect(@issue.assignee.name).to eq("Jack Smith")
    end
  end

  describe ".edit_issue" do
    before do
      stub_put("/projects/3/issues/33", "issue")
      @issue = Gitlab.edit_issue(3, 33, :title => 'title')
    end

    it "should get the correct resource" do
      expect(a_put("/projects/3/issues/33").
        with(:body => {:title => 'title'})).to have_been_made
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
        with(:body => {:state_event => 'close'})).to have_been_made
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
        with(:body => {:state_event => 'reopen'})).to have_been_made
    end

    it "should return information about an reopened issue" do
      expect(@issue.project_id).to eq(3)
      expect(@issue.assignee.name).to eq("Jack Smith")
    end
  end
end
