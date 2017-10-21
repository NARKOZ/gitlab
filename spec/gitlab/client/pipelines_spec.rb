require 'spec_helper'

describe Gitlab::Client do
  describe ".pipelines" do
    before do
      stub_get("/projects/3/pipelines", "pipelines")
      @pipelines = Gitlab.pipelines(3)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/pipelines")).to have_been_made
    end

    it "returns a paginated response of project's pipelines" do
      expect(@pipelines).to be_a Gitlab::PaginatedResponse
    end
  end

  describe ".pipeline" do
    before do
      stub_get("/projects/3/pipelines/46", "pipeline")
      @pipeline = Gitlab.pipeline(3, 46)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/pipelines/46")).to have_been_made
    end

    it "returns a single pipeline" do
      expect(@pipeline).to be_a Gitlab::ObjectifiedHash
    end

    it "returns information about a pipeline" do
      expect(@pipeline.id).to eq(46)
      expect(@pipeline.user.name).to eq("Administrator")
    end
  end

  describe ".create_pipeline" do
    before do
      stub_post("/projects/3/pipeline?ref=master", "pipeline_create")
      @pipeline_create = Gitlab.create_pipeline(3, 'master')
    end

    it "gets the correct resource" do
      expect(a_post("/projects/3/pipeline?ref=master")).to have_been_made
    end

    it "returns a single pipeline" do
      expect(@pipeline_create).to be_a Gitlab::ObjectifiedHash
    end

    it "returns information about a pipeline" do
      expect(@pipeline_create.user.name).to eq("Administrator")
    end
  end

  describe ".cancel_pipeline" do
    before do
      stub_post("/projects/3/pipelines/46/cancel", "pipeline_cancel")
      @pipeline_cancel = Gitlab.cancel_pipeline(3, 46)
    end

    it "gets the correct resource" do
      expect(a_post("/projects/3/pipelines/46/cancel")).to have_been_made
    end

    it "returns a single pipeline" do
      expect(@pipeline_cancel).to be_a Gitlab::ObjectifiedHash
    end

    it "returns information about a pipeline" do
      expect(@pipeline_cancel.user.name).to eq("Administrator")
    end
  end

  describe ".retry_pipeline" do
    before do
      stub_post("/projects/3/pipelines/46/retry", "pipeline_retry")
      @pipeline_retry = Gitlab.retry_pipeline(3, 46)
    end

    it "gets the correct resource" do
      expect(a_post("/projects/3/pipelines/46/retry")).to have_been_made
    end

    it "returns a single pipeline" do
      expect(@pipeline_retry).to be_a Gitlab::ObjectifiedHash
    end

    it "returns information about a pipeline" do
      expect(@pipeline_retry.user.name).to eq("Administrator")
    end
  end
end
