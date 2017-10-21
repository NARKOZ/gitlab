require 'spec_helper'

describe Gitlab::Client do
  describe ".milestones" do
    before do
      stub_get("/projects/3/milestones", "milestones")
      @milestones = Gitlab.milestones(3)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/milestones")).to have_been_made
    end

    it "returns a paginated response of project's milestones" do
      expect(@milestones).to be_a Gitlab::PaginatedResponse
      expect(@milestones.first.project_id).to eq(3)
    end
  end

  describe ".milestone" do
    before do
      stub_get("/projects/3/milestones/1", "milestone")
      @milestone = Gitlab.milestone(3, 1)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/milestones/1")).to have_been_made
    end

    it "returns information about a milestone" do
      expect(@milestone.project_id).to eq(3)
    end
  end

  describe ".milestone_issues" do
    before do
      stub_get("/projects/3/milestones/1/issues", "milestone_issues")
      @milestone_issues = Gitlab.milestone_issues(3, 1)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/milestones/1/issues")).to have_been_made
    end

    it "returns a paginated response of milestone's issues" do
      expect(@milestone_issues).to be_a Gitlab::PaginatedResponse
      expect(@milestone_issues.first.milestone.id).to eq(1)
    end
  end

  describe ".milestone_merge_requests" do
    before do
      stub_get("/projects/3/milestones/1/merge_requests", "milestone_merge_requests")
      @milestone_merge_requests = Gitlab.milestone_merge_requests(3, 1)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/milestones/1/merge_requests")).to have_been_made
    end

    it "returns a paginated response of milestone's merge_requests" do
      expect(@milestone_merge_requests).to be_a Gitlab::PaginatedResponse
      expect(@milestone_merge_requests.first.milestone.id).to eq(1)
    end
  end

  describe ".create_milestone" do
    before do
      stub_post("/projects/3/milestones", "milestone")
      @milestone = Gitlab.create_milestone(3, 'title')
    end

    it "gets the correct resource" do
      expect(a_post("/projects/3/milestones").
        with(body: { title: 'title' })).to have_been_made
    end

    it "returns information about a created milestone" do
      expect(@milestone.project_id).to eq(3)
    end
  end

  describe ".edit_milestone" do
    before do
      stub_put("/projects/3/milestones/33", "milestone")
      @milestone = Gitlab.edit_milestone(3, 33, title: 'title')
    end

    it "gets the correct resource" do
      expect(a_put("/projects/3/milestones/33").
        with(body: { title: 'title' })).to have_been_made
    end

    it "returns information about an edited milestone" do
      expect(@milestone.project_id).to eq(3)
    end
  end
end
