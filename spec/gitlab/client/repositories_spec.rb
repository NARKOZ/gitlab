require 'spec_helper'

describe Gitlab::Client do
  it { should respond_to :repo_tags }
  it { should respond_to :repo_branches }
  it { should respond_to :repo_branch }
  it { should respond_to :repo_commits }
  it { should respond_to :repo_commit }
  it { should respond_to :repo_commit_diff }

  describe ".tags" do
    before do
      stub_get("/projects/3/repository/tags", "project_tags")
      @tags = Gitlab.tags(3)
    end

    it "should get the correct resource" do
      a_get("/projects/3/repository/tags").should have_been_made
    end

    it "should return an array of repository tags" do
      @tags.should be_an Array
      @tags.first.name.should == "v2.8.2"
    end
  end

  describe ".commits" do
    before do
      stub_get("/projects/3/repository/commits", "project_commits").
        with(:query => {:ref_name => "api"})
      @commits = Gitlab.commits(3, :ref_name => "api")
    end

    it "should get the correct resource" do
      a_get("/projects/3/repository/commits").
        with(:query => {:ref_name => "api"}).should have_been_made
    end

    it "should return an array of repository commits" do
      @commits.should be_an Array
      @commits.first.id.should == "f7dd067490fe57505f7226c3b54d3127d2f7fd46"
    end
  end

  describe ".commit" do
    before do
      stub_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6", "project_commit")
      @commit = Gitlab.commit(3, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    end

    it "should get the correct resource" do
      a_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6")
        .should have_been_made
    end

    it "should return a repository commit" do
      @commit.id.should == "6104942438c14ec7bd21c6cd5bd995272b3faff6"
    end
  end

  describe ".commit_diff" do
    before do
      stub_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6/diff", "project_commit_diff")
      @diff = Gitlab.commit_diff(3, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    end

    it "should get the correct resource" do
      a_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6/diff")
        .should have_been_made
    end

    it "should return a diff of a commit" do
      @diff.new_path.should == "doc/update/5.4-to-6.0.md"
    end
  end
end
