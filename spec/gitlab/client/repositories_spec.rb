require 'spec_helper'

describe Gitlab::Client do
  it { should respond_to :repo_tags }
  it { should respond_to :repo_create_tag }
  it { should respond_to :repo_branches }
  it { should respond_to :repo_branch }
  it { should respond_to :repo_commits }
  it { should respond_to :repo_commit }
  it { should respond_to :repo_commit_diff }
  it { should respond_to :repo_commit_comments }
  it { should respond_to :repo_create_commit_comment }
  it { should respond_to :repo_tree }
  it { should respond_to :repo_compare}

  describe ".tags" do
    before do
      stub_get("/projects/3/repository/tags", "project_tags")
      @tags = Gitlab.tags(3)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/tags")).to have_been_made
    end

    it "should return an array of repository tags" do
      expect(@tags).to be_an Array
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

    it "should return an array of repository tree files (root level)" do
      expect(@tree).to be_an Array
      expect(@tree.first.name).to eq("app")
    end
  end

  describe ".commits" do
    before do
      stub_get("/projects/3/repository/commits", "project_commits").
        with(:query => {:ref_name => "api"})
      @commits = Gitlab.commits(3, :ref_name => "api")
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/commits").
        with(:query => {:ref_name => "api"})).to have_been_made
    end

    it "should return an array of repository commits" do
      expect(@commits).to be_an Array
      expect(@commits.first.id).to eq("f7dd067490fe57505f7226c3b54d3127d2f7fd46")
    end
  end

  describe ".commit" do
    before do
      stub_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6", "project_commit")
      @commit = Gitlab.commit(3, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6"))
        .to have_been_made
    end

    it "should return a repository commit" do
      expect(@commit.id).to eq("6104942438c14ec7bd21c6cd5bd995272b3faff6")
    end
  end

  describe ".commit_diff" do
    before do
      stub_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6/diff", "project_commit_diff")
      @diff = Gitlab.commit_diff(3, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6/diff"))
        .to have_been_made
    end

    it "should return a diff of a commit" do
      expect(@diff.new_path).to eq("doc/update/5.4-to-6.0.md")
    end
  end

  describe ".commit_comments" do
    before do
      stub_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6/comments", "project_commit_comments")
      @commit_comments = Gitlab.commit_comments(3, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6/comments"))
        .to have_been_made
    end

    it "should return commit's comments" do
      expect(@commit_comments).to be_an Array
      expect(@commit_comments.length).to eq(2)
      expect(@commit_comments[0].note).to eq("this is the 1st comment on commit 6104942438c14ec7bd21c6cd5bd995272b3faff6")
      expect(@commit_comments[0].author.id).to eq(11)
      expect(@commit_comments[1].note).to eq("another discussion point on commit 6104942438c14ec7bd21c6cd5bd995272b3faff6")
      expect(@commit_comments[1].author.id).to eq(12)
    end
  end

  describe ".create_commit_comment" do
    before do
      stub_post("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6/comments", "project_commit_comment")
      @merge_request = Gitlab.create_commit_comment(3, '6104942438c14ec7bd21c6cd5bd995272b3faff6', 'Nice code!')
    end

    it "should return information about the newly created comment" do
      expect(@merge_request.note).to eq('Nice code!')
      expect(@merge_request.author.id).to eq(1)
    end
  end

  describe ".compare" do
    before do
      stub_get("/projects/3/repository/compare", "compare_merge_request_diff").
        with(:query => {:from => "master", :to => "feature"})
      @diff = Gitlab.compare(3, 'master', 'feature')
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/compare").
        with(:query => {:from => "master", :to => "feature"})).to have_been_made
    end

    it "should get diffs of a merge request" do
      expect(@diff.diffs).to be_kind_of Array
      expect(@diff.diffs.last["new_path"]).to eq "files/js/application.js"
    end
  end
end
