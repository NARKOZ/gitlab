require 'spec_helper'

describe Gitlab::Client do
  describe ".merge_requests" do
    before do
      stub_get("/projects/3/merge_requests", "merge_requests")
      @merge_requests = Gitlab.merge_requests(3)
    end

    it "should get the correct resource" do
      a_get("/projects/3/merge_requests").should have_been_made
    end

    it "should return an array of project's merge requests" do
      @merge_requests.should be_an Array
      @merge_requests.first.project_id.should == 3
    end
  end

  describe ".merge_request" do
    before do
      stub_get("/projects/3/merge_request/1", "merge_request")
      @merge_request = Gitlab.merge_request(3, 1)
    end

    it "should get the correct resource" do
      a_get("/projects/3/merge_request/1").should have_been_made
    end

    it "should return information about a merge request" do
      @merge_request.project_id.should == 3
      @merge_request.assignee.name.should == "Jack Smith"
    end
  end

  describe ".create_merge_request" do
    before do
      stub_post("/projects/3/merge_requests", "create_merge_request")
    end

    it "should fail if it doesn't have a source_branch" do
      expect {
        Gitlab.create_merge_request(3, 'New merge request', :target_branch => 'master')
      }.to raise_error Gitlab::Error::MissingAttributes
    end

    it "should fail if it doesn't have a target_branch" do
      expect {
        Gitlab.create_merge_request(3, 'New merge request', :source_branch => 'dev')
      }.to raise_error Gitlab::Error::MissingAttributes
    end

    it "should return information about a merge request" do
      @merge_request = Gitlab.create_merge_request(3, 'New feature',
        :source_branch => 'api',
        :target_branch => 'master'
      )
      @merge_request.project_id.should == 3
      @merge_request.assignee.name.should == "Jack Smith"
      @merge_request.title.should == 'New feature'
    end
  end

  describe ".update_merge_request" do
    before do
      stub_put("/projects/3/merge_request/2", "update_merge_request")
      @merge_request = Gitlab.update_merge_request(3, 2,
        :assignee_id   => '1',
        :target_branch => 'master',
        :title         => 'A different new feature'
      )
    end

    it "should return information about a merge request" do
      @merge_request.project_id.should == 3
      @merge_request.assignee.name.should == "Jack Smith"
      @merge_request.title.should == 'A different new feature'
    end
  end

  describe ".create_merge_request_comment" do
    before do
      stub_post("/projects/3/merge_request/2/comments", "comment_merge_request")
    end

    it "should return information about a merge request" do
      @merge_request = Gitlab.create_merge_request_comment(3, 2, 'Cool Merge Request!')
      @merge_request.note.should == 'Cool Merge Request!'
      @merge_request.author.id == 1
    end
  end
end
