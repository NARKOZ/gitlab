require 'spec_helper'

describe Gitlab::Client do
  describe ".environments" do
    before do
      stub_get("/projects/3/environments", "environments")
      @environments = Gitlab.environments(3)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/environments")).to have_been_made
    end

    it "returns a paginated response of project's environments" do
      expect(@environments).to be_a Gitlab::PaginatedResponse
    end
  end

  describe ".environment" do
    before do
      stub_get("/projects/3/environments/12", "environment")
      @environment = Gitlab.environment(3, 12)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/environments/12")).to have_been_made
    end

    it "returns a single environment" do
      expect(@environment).to be_a Gitlab::ObjectifiedHash
    end

    it "returns information about an environment" do
      expect(@environment.id).to eq(12)
      expect(@environment.name).to eq("staging")
    end
  end

  describe ".create_environment" do
    context "without external_url" do
      before do
        stub_post("/projects/3/environments", "environment")
        @environment = Gitlab.create_environment(3, 'staging')
      end

      it "gets the correct resource" do
        expect(a_post("/projects/3/environments").with(body: { name: 'staging' })).to have_been_made
      end

      it "returns a single environment" do
        expect(@environment).to be_a Gitlab::ObjectifiedHash
      end

      it "returns information about an environment" do
        expect(@environment.name).to eq("staging")
      end
    end

    context "with external_url" do
      before do
        stub_post("/projects/3/environments", "environment")
        @environment = Gitlab.create_environment(3, 'staging', external_url: "https://staging.example.gitlab.com")
      end

      it "gets the correct resource" do
        expect(a_post("/projects/3/environments")
                 .with(body: { name: 'staging', external_url: "https://staging.example.gitlab.com" })).to have_been_made
      end
    end
  end

  describe ".edit_environment" do
    before do
      stub_put("/projects/3/environments/12", "environment")
      @environment = Gitlab.edit_environment(3, 12, {
        name: 'staging',
        external_url: "https://staging.example.gitlab.com"
      })
    end

    it "gets the correct resource" do
      expect(a_put("/projects/3/environments/12")
               .with(body: { name: 'staging', external_url: "https://staging.example.gitlab.com" })).to have_been_made
    end

    it "returns a single environment" do
      expect(@environment).to be_a Gitlab::ObjectifiedHash
    end

    it "returns information about an environment" do
      expect(@environment.name).to eq("staging")
    end
  end

  describe ".delete_environment" do
    before do
      stub_delete("/projects/3/environments/12", "environment")
      @environment = Gitlab.delete_environment(3, 12)
    end

    it "gets the correct resource" do
      expect(a_delete("/projects/3/environments/12")).to have_been_made
    end

    it "returns a single pipeline" do
      expect(@environment).to be_a Gitlab::ObjectifiedHash
    end

    it "returns information about a pipeline" do
      expect(@environment.name).to eq("staging")
    end
  end

  describe ".stop_environment" do
    before do
      stub_post("/projects/3/environments/12/stop", "environment")
      @environment = Gitlab.stop_environment(3, 12)
    end

    it "gets the correct resource" do
      expect(a_post("/projects/3/environments/12/stop")).to have_been_made
    end

    it "returns a single pipeline" do
      expect(@environment).to be_a Gitlab::ObjectifiedHash
    end

    it "returns information about a pipeline" do
      expect(@environment.name).to eq("staging")
    end
  end
end
