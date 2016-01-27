require 'spec_helper'

describe Gitlab::Client do
  describe ".builds" do
    before do
      stub_get("/projects/3/builds", "builds")
      @builds = Gitlab.builds(3)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/builds")).to have_been_made
    end

    it "should return a paginated response of project's builds" do
      expect(@builds).to be_a Gitlab::PaginatedResponse
    end
  end
  
  describe ".build" do
    before do
      stub_get("/projects/3/build/8", "build")
      @build = Gitlab.build(3, 8)
    end
    
    it "should get the correct resource" do
      expect(a_get("/projects/3/build/8")).to have_been_made
    end

    it "should return a single build" do
      expect(@build).to be_a Gitlab::ObjectifiedHash
    end
    
    it "should return information about a build" do
      expect(@build.id).to eq(8)
      expect(@build.user.name).to eq("John Smith")
    end
  end

  describe ".builds_commits" do
    before do
      stub_get("/projects/3/repository/commits/0ff3ae198f8601a285adcf5c0fff204ee6fba5fd/builds", "builds_commits")
      @builds_commits = Gitlab.commit_builds(3, "0ff3ae198f8601a285adcf5c0fff204ee6fba5fd")
    end
    
    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/commits/0ff3ae198f8601a285adcf5c0fff204ee6fba5fd/builds")).to have_been_made
    end

    it "should return a paginated response of commit builds" do
      expect(@builds_commits).to be_a Gitlab::PaginatedResponse
    end
    
    it "should return information about the builds" do
      expect(@builds_commits.count).to eq(2)
    end
  end

  describe ".build_cancel" do
    before do
      stub_post("/projects/3/builds/8/cancel", "build_cancel")
      @build_cancel = Gitlab.build_cancel(3, 8)
    end
    
    it "should get the correct resource" do
      expect(a_post("/projects/3/builds/8/cancel")).to have_been_made
    end

    it "should return a single build" do
      expect(@build_cancel).to be_a Gitlab::ObjectifiedHash
    end
    
    it "should return information about a build" do
      expect(@build_cancel.commit.author_name).to eq("John Smith")
    end
  end
  
  describe ".build_retry" do
    before do
      stub_post("/projects/3/builds/69/retry", "build_retry")
      @build_retry = Gitlab.build_retry(3, 69)
    end
    
    it "should get the correct resource" do
      expect(a_post("/projects/3/builds/69/retry")).to have_been_made
    end

    it "should return a single build" do
      expect(@build_retry).to be_a Gitlab::ObjectifiedHash
    end
    
    it "should return information about a build" do
      expect(@build_retry.commit.author_name).to eq("John Smith")
    end
  end

end
