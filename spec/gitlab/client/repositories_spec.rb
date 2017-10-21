require 'spec_helper'

describe Gitlab::Client do
  it { is_expected.to respond_to :repo_tags }
  it { is_expected.to respond_to :repo_create_tag }
  it { is_expected.to respond_to :repo_branches }
  it { is_expected.to respond_to :repo_branch }
  it { is_expected.to respond_to :repo_tree }
  it { is_expected.to respond_to :repo_compare }

  describe ".tags" do
    before do
      stub_get("/projects/3/repository/tags", "project_tags")
      @tags = Gitlab.tags(3)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/repository/tags")).to have_been_made
    end

    it "returns a paginated response of repository tags" do
      expect(@tags).to be_a Gitlab::PaginatedResponse
      expect(@tags.first.name).to eq("v2.8.2")
    end
  end

  describe ".create_tag" do
    context "when lightweight" do
      before do
        stub_post("/projects/3/repository/tags", "project_tag_lightweight")
        @tag = Gitlab.create_tag(3, 'v1.0.0', '2695effb5807a22ff3d138d593fd856244e155e7')
      end

      it "gets the correct resource" do
        expect(a_post("/projects/3/repository/tags")).to have_been_made
      end

      it "returns information about a new repository tag" do
        expect(@tag.name).to eq("v1.0.0")
        expect(@tag.message).to eq(nil)
      end
    end

    context "when annotated" do
      before do
        stub_post("/projects/3/repository/tags", "project_tag_annotated")
        @tag = Gitlab.create_tag(3, 'v1.1.0', '2695effb5807a22ff3d138d593fd856244e155e7', 'Release 1.1.0')
      end

      it "gets the correct resource" do
        expect(a_post("/projects/3/repository/tags")).to have_been_made
      end

      it "returns information about a new repository tag" do
        expect(@tag.name).to eq("v1.1.0")
        expect(@tag.message).to eq("Release 1.1.0")
      end
    end
  end

  describe ".tree" do
    before do
      stub_get("/projects/3/repository/tree", "tree")
      @tree = Gitlab.tree(3)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/repository/tree")).to have_been_made
    end

    it "returns a paginated response of repository tree files (root level)" do
      expect(@tree).to be_a Gitlab::PaginatedResponse
      expect(@tree.first.name).to eq("app")
    end
  end

  describe ".compare" do
    before do
      stub_get("/projects/3/repository/compare", "compare_merge_request_diff").
        with(query: { from: "master", to: "feature" })
      @diff = Gitlab.compare(3, 'master', 'feature')
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/repository/compare").
        with(query: { from: "master", to: "feature" })).to have_been_made
    end

    it "gets diffs of a merge request" do
      expect(@diff.diffs).to be_kind_of Array
      expect(@diff.diffs.last["new_path"]).to eq "files/js/application.js"
    end
  end
end
