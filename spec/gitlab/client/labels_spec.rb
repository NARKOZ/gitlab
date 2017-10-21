require 'spec_helper'

describe Gitlab::Client do
  describe ".labels" do
    before do
      stub_get("/projects/3/labels", "labels")
      @labels = Gitlab.labels(3)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/labels")).to have_been_made
    end

    it "returns a paginated response of project's labels" do
      expect(@labels).to be_a Gitlab::PaginatedResponse
      expect(@labels.first.name).to eq("Backlog")
    end
  end

  describe ".delete" do
    before do
      stub_delete("/projects/3/labels", "label")
      @label = Gitlab.delete_label(3, "Backlog")
    end

    it "gets the correct resource" do
      expect(a_delete("/projects/3/labels").
             with(body: { name: 'Backlog' })).to have_been_made
    end

    it "returns information about a deleted snippet" do
      expect(@label.name).to eq("Backlog")
    end
  end

  describe ".edit_label" do
    before do
      stub_put("/projects/3/labels", "label")
      @label = Gitlab.edit_label(3, "TODO", new_name: 'Backlog')
    end

    it "gets the correct resource" do
      expect(a_put("/projects/3/labels").
             with(body: { name: 'TODO', new_name: "Backlog" })).to have_been_made
    end

    it "returns information about an edited label" do
      expect(@label.name).to eq("Backlog")
    end
  end

  describe ".create_label" do
    before do
      stub_post("/projects/3/labels", "label")
      @label = Gitlab.create_label(3, 'Backlog', '#DD10AA')
    end

    it "gets the correct resource" do
      expect(a_post("/projects/3/labels").
             with(body: { name: 'Backlog', color: '#DD10AA' })).to have_been_made
    end

    it "returns information about a created label" do
      expect(@label.name).to eq('Backlog')
      expect(@label.color).to eq('#DD10AA')
    end
  end

  describe ".subscribe_to_label" do
    before do
      stub_post("/projects/3/labels/Backlog/subscribe", "label")
      @label = Gitlab.subscribe_to_label(3, 'Backlog')
    end

    it "gets the correct resource" do
      expect(a_post("/projects/3/labels/Backlog/subscribe")).to have_been_made
    end

    it "returns information about the label subscribed to" do
      expect(@label.name).to eq('Backlog')
      expect(@label.subscribed).to eq(true)
    end
  end

  describe ".unsubscribe_from_label" do
    before do
      stub_post("/projects/3/labels/Backlog/unsubscribe", "label_unsubscribe")
      @label = Gitlab.unsubscribe_from_label(3, 'Backlog')
    end

    it "gets the correct resource" do
      expect(a_post("/projects/3/labels/Backlog/unsubscribe")).to have_been_made
    end

    it "returns information about the label subscribed to" do
      expect(@label.name).to eq('Backlog')
      expect(@label.subscribed).to eq(false)
    end
  end
end
