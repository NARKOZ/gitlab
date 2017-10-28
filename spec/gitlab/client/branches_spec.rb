require 'spec_helper'

describe Gitlab::Client do
  it { is_expected.to respond_to :repo_branches }
  it { is_expected.to respond_to :repo_branch }
  it { is_expected.to respond_to :repo_protect_branch }
  it { is_expected.to respond_to :repo_unprotect_branch }

  describe ".branches" do
    before do
      stub_get("/projects/3/repository/branches", "branches")
      @branches = Gitlab.branches(3)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/repository/branches")).to have_been_made
    end

    it "returns a paginated response of repository branches" do
      expect(@branches).to be_a Gitlab::PaginatedResponse
      expect(@branches.first.name).to eq("api")
    end
  end

  describe ".branch" do
    before do
      stub_get("/projects/3/repository/branches/api", "branch")
      @branch = Gitlab.branch(3, "api")
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/repository/branches/api")).to have_been_made
    end

    it "returns information about a repository branch" do
      expect(@branch.name).to eq("api")
    end
  end

  describe ".protect_branch" do
    before do
      stub_post("/projects/3/protected_branches", "branch")
    end

    context "without options" do
      before do
        @branch = Gitlab.protect_branch(3, "api")
      end

      it "updates the correct resource" do
        expect(a_post("/projects/3/protected_branches")).to have_been_made
      end

      it "returns information about a protected repository branch" do
        expect(@branch.name).to eq("api")
      end
    end

    context "with options" do
      before do
        @branch = Gitlab.protect_branch(3, "api", developers_can_push: true)
      end

      it "updates the correct resource with the correct options" do
        expect(
          a_post("/projects/3/protected_branches").with(body: { name: "api", developers_can_push: 'true' })
        ).to have_been_made
      end
    end
  end

  describe ".unprotect_branch" do
    before do
      stub_delete("/projects/3/protected_branches/api","branch")
      @branch = Gitlab.unprotect_branch(3, "api")
    end

    it "gets the correct resource" do
      expect(a_delete("/projects/3/protected_branches/api")).to have_been_made
    end

    it "returns information about an unprotected repository branch" do
      expect(@branch.name).to eq("api")
    end
  end

  describe ".create_branch" do
    before do
      stub_post("/projects/3/repository/branches", "branch")
      @branch = Gitlab.create_branch(3, "api", "master")
    end

    it "gets the correct resource" do
      expect(a_post("/projects/3/repository/branches")).to have_been_made
    end

    it "returns information about a new repository branch" do
      expect(@branch.name).to eq("api")
    end
  end

  describe ".delete_branch" do
    before do
      stub_delete("/projects/3/repository/branches/api", "branch_delete")
      @branch = Gitlab.delete_branch(3, "api")
    end

    it "gets the correct resource" do
      expect(a_delete("/projects/3/repository/branches/api")).to have_been_made
    end

    it "returns information about the deleted repository branch" do
      expect(@branch.branch_name).to eq("api")
    end
  end
end
