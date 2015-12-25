require 'spec_helper'

describe Gitlab::Client do
  describe ".service" do
    before do
      stub_get("/projects/3/services/redmine", "service")
      @service = Gitlab.service(3, :redmine)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/services/redmine")).to have_been_made
    end

    it "should return a information about a service of project" do
      expect(@service.id).to eq 38
      expect(@service.title).to eq("Redmine")
      expect(@service.properties.project_url).to eq("https://example.com/projects/test_project/issue")
    end
  end

  describe ".change_service" do
    before do
      stub_put("/projects/3/services/redmine", "service")
      @service = Gitlab.change_service(3, :redmine, new_issue_url: 'https://example.com/projects/test_project/issues/new',
                                                    project_url: 'https://example.com/projects/test_project/issues',
                                                    issues_url: 'https://example.com/issues/:id')
    end

    it "should get the correct resource" do
      body = {new_issue_url: 'https://example.com/projects/test_project/issues/new',
              project_url: 'https://example.com/projects/test_project/issues',
              issues_url: 'https://example.com/issues/:id'}
      expect(a_put("/projects/3/services/redmine").with(body: body)).to have_been_made
    end

    it "should return information about a new service" do
      expect(@service).to be_truthy
    end
  end

  describe ".delete_servoce" do
    before do
      stub_delete("/projects/3/services/redmine", "service")
      @service = Gitlab.delete_service(3, :redmine)
    end

    it "should get the correct resource" do
      expect(a_delete("/projects/3/services/redmine")).to have_been_made
    end

    it "should return information about a deleted service" do
      expect(@service).to be_truthy
    end
  end
end
