require 'spec_helper'

describe Gitlab::Client do
  describe ".deployments" do
    before do
      stub_get("/projects/3/deployments", "deployments")
      @deployments = Gitlab.deployments(3)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/deployments")).to have_been_made
    end

    it "returns a paginated response of project's deployments" do
      expect(@deployments).to be_a Gitlab::PaginatedResponse
    end
  end

  describe ".deployment" do
    before do
      stub_get("/projects/3/deployments/42", "deployment")
      @deployment = Gitlab.deployment(3, 42)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/deployments/42")).to have_been_made
    end

    it "returns a single deployment" do
      expect(@deployment).to be_a Gitlab::ObjectifiedHash
    end

    it "returns information about an deployment" do
      expect(@deployment.id).to eq(42)
      expect(@deployment.deployable.commit.id).to eq("a91957a858320c0e17f3a0eca7cfacbff50ea29a")
    end
  end
end
