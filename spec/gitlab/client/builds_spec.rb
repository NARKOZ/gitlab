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
      stub_get("/projects/3/builds/8", "build")
      @build = Gitlab.build(3, 8)
    end
    
    it "should get the correct resource" do
      expect(a_get("/projects/3/builds/8")).to have_been_made
    end

    it "should return a single build" do
      expect(@build).to be_a Gitlab::ObjectifiedHash
    end
    
    it "should return information about a build" do
      expect(@build.id).to eq(8)
      expect(@build.user.name).to eq("John Smith")
    end
  end

  describe ".build_artifacts" do
    context "when successful request" do
      before do
        fixture = load_fixture('build_artifacts')
        fixture.set_encoding(Encoding::ASCII_8BIT)
        stub_request(:get, "#{Gitlab.endpoint}/projects/3/builds/8/artifacts").
          with(headers: { 'PRIVATE-TOKEN' => Gitlab.private_token }).
          to_return(body: fixture.read, headers: { 'Content-Disposition' => "attachment; filename=artifacts.zip" })
        @build_artifacts = Gitlab.build_artifacts(3, 8)
      end
      
      it "should get the correct resource" do
        expect(a_get("/projects/3/builds/8/artifacts")).to have_been_made
      end
      
      it "should return a FileResponse" do
        expect(@build_artifacts).to be_a Gitlab::FileResponse
      end
      
      it "should return a file with filename" do
        expect(@build_artifacts.filename).to eq "artifacts.zip"
      end
    end

    context "when bad request" do
      it "should throw an exception" do
        stub_get("/projects/3/builds/8/artifacts", "error_project_not_found", 404)
        expect{ Gitlab.build_artifacts(3, 8) }.to raise_error(Gitlab::Error::NotFound, "Server responded with code 404, message: 404 Project Not Found. Request URI: #{Gitlab.endpoint}/projects/3/builds/8/artifacts")
      end
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

  describe ".build_erase" do
    before do
      stub_post("/projects/3/builds/69/erase", "build_erase")
      @build_retry = Gitlab.build_erase(3, 69)
    end
    
    it "should get the correct resource" do
      expect(a_post("/projects/3/builds/69/erase")).to have_been_made
    end

    it "should return a single build" do
      expect(@build_retry).to be_a Gitlab::ObjectifiedHash
    end
    
    it "should return information about a build" do
      expect(@build_retry.commit.author_name).to eq("John Smith")
    end
  end
end
