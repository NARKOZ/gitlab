require 'spec_helper'

describe Gitlab::Client do
  it { should respond_to :repo_tags }
  it { should respond_to :repo_create_tag }
  it { should respond_to :repo_branches }
  it { should respond_to :repo_branch }
  it { should respond_to :repo_tree }
  it { should respond_to :repo_compare }

  describe ".tags" do
    before do
      stub_get("/projects/3/repository/tags", "project_tags")
      @tags = Gitlab.tags(3)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/tags")).to have_been_made
    end

    it "should return a paginated response of repository tags" do
      expect(@tags).to be_a Gitlab::PaginatedResponse
      expect(@tags.first.name).to eq("v2.8.2")
    end
  end

  describe ".file_contents" do
    before do
      stub_get("/projects/3/repository/blobs/master?filepath=Gemfile", "raw_file")
      @file_contents = Gitlab.file_contents(3, "Gemfile")
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/blobs/master?filepath=Gemfile")).to have_been_made
    end

    it "should return file contents" do
      expect(@file_contents).to eq("source 'https://rubygems.org'\ngem 'rails', '4.1.2'\n")
    end
  end

  describe ".create_tag" do
    context "when lightweight" do
      before do
        stub_post("/projects/3/repository/tags", "project_tag_lightweight")
        @tag = Gitlab.create_tag(3, 'v1.0.0', '2695effb5807a22ff3d138d593fd856244e155e7')
      end

      it "should get the correct resource" do
        expect(a_post("/projects/3/repository/tags")).to have_been_made
      end

      it "should return information about a new repository tag" do
        expect(@tag.name).to eq("v1.0.0")
        expect(@tag.message).to eq(nil)
      end
    end

    context "when annotated" do
      before do
        stub_post("/projects/3/repository/tags", "project_tag_annotated")
        @tag = Gitlab.create_tag(3, 'v1.1.0', '2695effb5807a22ff3d138d593fd856244e155e7', 'Release 1.1.0')
      end

      it "should get the correct resource" do
        expect(a_post("/projects/3/repository/tags")).to have_been_made
      end

      it "should return information about a new repository tag" do
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

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/tree")).to have_been_made
    end

    it "should return a paginated response of repository tree files (root level)" do
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

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/compare").
        with(query: { from: "master", to: "feature" })).to have_been_made
    end

    it "should get diffs of a merge request" do
      expect(@diff.diffs).to be_kind_of Array
      expect(@diff.diffs.last["new_path"]).to eq "files/js/application.js"
    end
  end
end
