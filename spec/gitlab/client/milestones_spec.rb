require 'spec_helper'

describe Gitlab::Client do
  describe ".milestones" do
    before do
      stub_get("/projects/3/milestones", "milestones")
      @milestones = Gitlab.milestones(3)
    end

    it "should get the correct resource" do
      a_get("/projects/3/milestones").should have_been_made
    end

    it "should return an array of project's milestones" do
      @milestones.should be_an Array
      @milestones.first.project_id.should == 3
    end
  end

  describe ".milestone" do
    before do
      stub_get("/projects/3/milestones/1", "milestone")
      @milestone = Gitlab.milestone(3, 1)
    end

    it "should get the correct resource" do
      a_get("/projects/3/milestones/1").should have_been_made
    end

    it "should return information about a milestone" do
      @milestone.project_id.should == 3
    end
  end

  describe ".create_milestone" do
    before do
      stub_post("/projects/3/milestones", "milestone")
      @milestone = Gitlab.create_milestone(3, 'title')
    end

    it "should get the correct resource" do
      a_post("/projects/3/milestones").
        with(:body => {:title => 'title'}).should have_been_made
    end

    it "should return information about a created milestone" do
      @milestone.project_id.should == 3
    end
  end

  describe ".edit_milestone" do
    before do
      stub_put("/projects/3/milestones/33", "milestone")
      @milestone = Gitlab.edit_milestone(3, 33, :title => 'title')
    end

    it "should get the correct resource" do
      a_put("/projects/3/milestones/33").
        with(:body => {:title => 'title'}).should have_been_made
    end

    it "should return information about an edited milestone" do
      @milestone.project_id.should == 3
    end
  end
end
