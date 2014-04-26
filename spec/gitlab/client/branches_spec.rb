require 'spec_helper'

describe Gitlab::Client do
  it { should respond_to :repo_branches }
  it { should respond_to :repo_branch }
  it { should respond_to :repo_protect_branch }
  it { should respond_to :repo_unprotect_branch }

  describe ".branches" do
    before do
      stub_get("/projects/3/repository/branches", "branches")
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
      stub_get("/projects/3/repository/branches/api", "branch")
      @branch = Gitlab.branch(3, "api")
    end

    it "should get the correct resource" do
      a_get("/projects/3/repository/branches/api").should have_been_made
    end

    it "should return information about a repository branch" do
      @branch.name.should == "api"
    end
  end

  describe ".protect_branch" do
    before do
      stub_put("/projects/3/repository/branches/api/protect", "protect_branch")
      @branch = Gitlab.protect_branch(3, "api")
    end

    it "should get the correct resource" do
      a_put("/projects/3/repository/branches/api/protect").should have_been_made
    end

    it "should return information about a protected repository branch" do
      @branch.name.should == "api"
      @branch.protected.should == true
    end
  end

  describe ".unprotect_branch" do
    before do
      stub_put("/projects/3/repository/branches/api/unprotect", "unprotect_branch")
      @branch = Gitlab.unprotect_branch(3, "api")
    end

    it "should get the correct resource" do
      a_put("/projects/3/repository/branches/api/unprotect").should have_been_made
    end

    it "should return information about an unprotected repository branch" do
      @branch.name.should == "api"
      @branch.protected.should == false
    end
  end

  describe ".create_branch" do
    context "with branch name" do
      before do
        stub_post("/projects/3/repository/branches", "create_branch")
        @branch = Gitlab.create_branch(3, "api","master")
      end

      it "should get the correct resource" do
        a_post("/projects/3/repository/branches").should have_been_made
      end

      it "should return information about a new repository branch" do
        @branch.name.should == "api"
      end
    end
    context "with commit hash" do
      before do
        stub_post("/projects/3/repository/branches", "create_branch")
        @branch = Gitlab.create_branch(3, "api","949b1df930bedace1dbd755aaa4a82e8c451a616")
      end

      it "should get the correct resource" do
        a_post("/projects/3/repository/branches").should have_been_made
      end

      it "should return information about a new repository branch" do
        @branch.name.should == "api"
      end
    end
  end

end
