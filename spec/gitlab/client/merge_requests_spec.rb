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
end
