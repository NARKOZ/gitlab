require 'spec_helper'

describe Gitlab::Client do
  it { is_expected.to respond_to :repo_tags }
  it { is_expected.to respond_to :repo_tag }
  it { is_expected.to respond_to :repo_create_tag }
  it { is_expected.to respond_to :repo_delete_tag }
  it { is_expected.to respond_to :repo_create_release }
  it { is_expected.to respond_to :repo_update_release }

  describe '.tags' do
    before do
      stub_get("/projects/3/repository/tags", "tags")
      @tags = Gitlab.tags(3)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/repository/tags")).to have_been_made
    end

    it "returns a paginated response of repository tags" do
      expect(@tags).to be_a Gitlab::PaginatedResponse
      expect(@tags.map(&:name)).to eq(%w[0.0.2 0.0.1])
    end
  end

  describe ".tag" do
    before do
      stub_get("/projects/3/repository/tags/0.0.1", "tag")
      @tag = Gitlab.tag(3, "0.0.1")
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/repository/tags/0.0.1")).to have_been_made
    end

    it "returns information about a repository tag" do
      expect(@tag.name).to eq("0.0.1")
    end
  end

  describe ".create_tag" do
    before do
      stub_post("/projects/3/repository/tags", "tag_create")
      @tag = Gitlab.create_tag(3, "0.0.1", "master", 'this tag is annotated', 'and it has release notes')
    end

    it "gets the correct resource" do
      expect(a_post("/projects/3/repository/tags")).to have_been_made
    end

    it "returns information about a new repository tag" do
      expect(@tag.name).to eq("0.0.1")
      expect(@tag.message).to eq('this tag is annotated')
    end

    it "returns detailed information" do
      expect(@tag.release.description).to eq('and it has release notes')
    end
  end

  describe ".delete_tag" do
    before do
      stub_delete("/projects/3/repository/tags/0.0.1", "tag_delete")
      @tag = Gitlab.delete_tag(3, "0.0.1")
    end

    it "gets the correct resource" do
      expect(a_delete("/projects/3/repository/tags/0.0.1")).to have_been_made
    end

    it "returns information about the deleted repository tag" do
      expect(@tag.tag_name).to eq("0.0.1")
    end
  end

  describe ".create_release" do
    before do
      stub_post("/projects/3/repository/tags/0.0.1/release", "release_create")
      @tag = Gitlab.create_release(3, "0.0.1", "Amazing release. Wow")
    end

    it "gets the correct resource" do
      expect(a_post("/projects/3/repository/tags/0.0.1/release")).to have_been_made
    end

    it "returns information about the tag and the release" do
      expect(@tag.tag_name).to eq("0.0.1")
      expect(@tag.description).to eq("Amazing release. Wow")
    end
  end

  describe ".update_release" do
    before do
      stub_put("/projects/3/repository/tags/0.0.1/release", "release_update")
      @tag = Gitlab.update_release(3, "0.0.1", 'Amazing release. Wow')
    end

    it "updates the correct resource" do
      expect(a_put("/projects/3/repository/tags/0.0.1/release")).to have_been_made
    end

    it "returns information about the tag" do
      expect(@tag.tag_name).to eq("0.0.1")
      expect(@tag.description).to eq('Amazing release. Wow')
    end
  end
end
