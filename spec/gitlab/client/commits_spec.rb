require 'spec_helper'

describe Gitlab::Client do
  it { should respond_to :repo_commits }
  it { should respond_to :repo_commit }
  it { should respond_to :repo_commit_diff }
  it { should respond_to :repo_commit_comments }
  it { should respond_to :repo_create_commit_comment }

  describe ".commits" do
    before do
      stub_get("/projects/3/repository/commits", "commits")
      @commits = Gitlab.commits(3)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/commits")).to have_been_made
    end

    it "should return an array of repository commits" do
      expect(@commits).to be_an Array
      expect(@commits.first.id).to eq("ed899a2f4b50b4370feeea94676502b42383c746")
    end
  end

  describe ".commit" do
    before do
      stub_get("/projects/3/repository/commits/ed899a2f4b50b4370feeea94676502b42383c746", "commit")
      @commit = Gitlab.commit(3, "ed899a2f4b50b4370feeea94676502b42383c746")
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/commits/ed899a2f4b50b4370feeea94676502b42383c746")).to have_been_made
    end

    it "should return information about a repository commit" do
      expect(@commit.id).to eq("ed899a2f4b50b4370feeea94676502b42383c746")
    end
  end

  describe ".commit_diff" do
    before do
      stub_get("/projects/3/repository/commits/ed899a2f4b50b4370feeea94676502b42383c746/diff", "commit_diff")
      @diff = Gitlab.commit_diff(3, "ed899a2f4b50b4370feeea94676502b42383c746")
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/commits/ed899a2f4b50b4370feeea94676502b42383c746/diff")).to have_been_made
    end

    it "should return an array of repository diffs" do
      expect(@diff).to be_an Array
      expect(@diff.first.b_mode).to eq("100644")
    end
  end

  describe ".commit_comments" do
    before do
      stub_get("/projects/3/repository/commits/ed899a2f4b50b4370feeea94676502b42383c746/comments", "commit_comments")
      @comments = Gitlab.commit_comments(3, "ed899a2f4b50b4370feeea94676502b42383c746")
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/commits/ed899a2f4b50b4370feeea94676502b42383c746/comments")).to have_been_made
    end

    it "should return an array of repository commit comments" do
      expect(@comments).to be_an Array
      expect(@comments.first.note).to eq("text1")
    end
  end

  describe ".create_commit_comment" do
    before do
      stub_post("/projects/3/repository/commits/ed899a2f4b50b4370feeea94676502b42383c746/comments", "create_commit_comment")
      @comment = Gitlab.create_commit_comment(3, "ed899a2f4b50b4370feeea94676502b42383c746", "text1")
    end

    it "should get the correct resource" do
      expect(a_post("/projects/3/repository/commits/ed899a2f4b50b4370feeea94676502b42383c746/comments")).to have_been_made
    end

    it "should return information about a new repository branch" do
      expect(@comment.note).to eq("text1")
    end
  end
end
