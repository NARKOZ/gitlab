require 'spec_helper'

describe Gitlab::Client do
  it { should respond_to :repo_tags }
  it { should respond_to :repo_branches }
  it { should respond_to :repo_branch }
  it { should respond_to :repo_commits }

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

  describe ".branches" do
    before do
      stub_get("/projects/3/repository/branches", "project_branches")
      @branches = Gitlab.branches(3)
    end

    it "should get the correct resource" do
      a_get("/projects/3/repository/branches").should have_been_made
    end

    it "should return an array of repository branches" do
      @branches.should be_an Array
      @branches.first.name.should == "api"
    end
  end

  describe ".branch" do
    before do
      stub_get("/projects/3/repository/branches/api", "project_branch")
      @branch = Gitlab.branch(3, "api")
    end

    it "should get the correct resource" do
      a_get("/projects/3/repository/branches/api").should have_been_made
    end

    it "should return information about a repository branch" do
      @branch.name.should == "api"
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
end
