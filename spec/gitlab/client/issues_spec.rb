require 'spec_helper'

describe Gitlab::Client do
  describe ".issues" do
    context "with project ID passed" do
      before do
        stub_get("/projects/3/issues", "project_issues")
        @issues = Gitlab.issues(3)
      end

      it "should get the correct resource" do
        a_get("/projects/3/issues").should have_been_made
      end

      it "should return an array of project's issues" do
        @issues.should be_an Array
        @issues.first.project_id.should == 3
      end
    end

    context "without project ID passed" do
      before do
        stub_get("/issues", "issues")
        @issues = Gitlab.issues
      end

      it "should get the correct resource" do
        a_get("/issues").should have_been_made
      end

      it "should return an array of user's issues" do
        @issues.should be_an Array
        @issues.first.closed.should be_false
        @issues.first.author.name.should == "John Smith"
      end
    end
  end

  describe ".issue" do
    before do
      stub_get("/projects/3/issues/33", "issue")
      @issue = Gitlab.issue(3, 33)
    end

    it "should get the correct resource" do
      a_get("/projects/3/issues/33").should have_been_made
    end

    it "should return information about an issue" do
      @issue.project_id.should == 3
      @issue.assignee.name.should == "Jack Smith"
    end
  end

  describe ".create_issue" do
    before do
      stub_post("/projects/3/issues", "issue")
      @issue = Gitlab.create_issue(3, 'title')
    end

    it "should get the correct resource" do
      a_post("/projects/3/issues").
        with(:body => {:title => 'title'}).should have_been_made
    end

    it "should return information about a created issue" do
      @issue.project_id.should == 3
      @issue.assignee.name.should == "Jack Smith"
    end
  end

  describe ".edit_issue" do
    before do
      stub_put("/projects/3/issues/33", "issue")
      @issue = Gitlab.edit_issue(3, 33, :title => 'title')
    end

    it "should get the correct resource" do
      a_put("/projects/3/issues/33").
        with(:body => {:title => 'title'}).should have_been_made
    end

    it "should return information about an edited issue" do
      @issue.project_id.should == 3
      @issue.assignee.name.should == "Jack Smith"
    end
  end

  describe ".close_issue" do
    before do
      stub_put("/projects/3/issues/33", "issue")
      @issue = Gitlab.close_issue(3, 33)
    end

    it "should get the correct resource" do
      a_put("/projects/3/issues/33").
        with(:body => {:closed => '1'}).should have_been_made
    end

    it "should return information about an edited issue" do
      @issue.project_id.should == 3
      @issue.assignee.name.should == "Jack Smith"
    end
  end

  describe ".reopen_issue" do
    before do
      stub_put("/projects/3/issues/33", "issue")
      @issue = Gitlab.reopen_issue(3, 33)
    end

    it "should get the correct resource" do
      a_put("/projects/3/issues/33").
        with(:body => {:closed => '0'}).should have_been_made
    end

    it "should return information about an edited issue" do
      @issue.project_id.should == 3
      @issue.assignee.name.should == "Jack Smith"
    end
  end
end
