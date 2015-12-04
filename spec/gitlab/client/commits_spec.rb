require 'spec_helper'

describe Gitlab::Client do
  it { should respond_to :repo_commits }
  it { should respond_to :repo_commit }
  it { should respond_to :repo_commit_diff }
  it { should respond_to :repo_commit_comments }
  it { should respond_to :repo_create_commit_comment }
  it { should respond_to :repo_commit_status }
  it { should respond_to :repo_update_commit_status }

  describe ".commits" do
    before do
      stub_get("/projects/3/repository/commits", "project_commits").
        with(query: { ref_name: "api" })
      @commits = Gitlab.commits(3, ref_name: "api")
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/commits").
        with(query: { ref_name: "api" })).to have_been_made
    end

    it "should return a paginated response of repository commits" do
      expect(@commits).to be_a Gitlab::PaginatedResponse
      expect(@commits.first.id).to eq("f7dd067490fe57505f7226c3b54d3127d2f7fd46")
    end
  end

  describe ".commit" do
    before do
      stub_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6", "project_commit")
      @commit = Gitlab.commit(3, '6104942438c14ec7bd21c6cd5bd995272b3faff6')
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6")).
        to have_been_made
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
      expect(a_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6/diff")).
        to have_been_made
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
      expect(a_get("/projects/3/repository/commits/6104942438c14ec7bd21c6cd5bd995272b3faff6/comments")).
        to have_been_made
    end

    it "should return commit's comments" do
      expect(@commit_comments).to be_a Gitlab::PaginatedResponse
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

  describe ".commit_status" do
    before do
      stub_get("/projects/6/repository/commits/7d938cb8ac15788d71f4b67c035515a160ea76d8/statuses", 'project_commit_status').
        with(query: { all: 'true' })
      @statuses = Gitlab.commit_status(6, '7d938cb8ac15788d71f4b67c035515a160ea76d8', all: true)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/6/repository/commits/7d938cb8ac15788d71f4b67c035515a160ea76d8/statuses").
        with(query: { all: true }))
    end

    it "should get statuses of a commit" do
      expect(@statuses).to be_kind_of Gitlab::PaginatedResponse
      expect(@statuses.first.sha).to eq('7d938cb8ac15788d71f4b67c035515a160ea76d8')
      expect(@statuses.first.ref).to eq('decreased-spec')
      expect(@statuses.first.status).to eq('failed')
      expect(@statuses.last.sha).to eq('7d938cb8ac15788d71f4b67c035515a160ea76d8')
      expect(@statuses.last.status).to eq('success')
    end
  end

  describe ".update_commit_status" do
    before do
      stub_post("/projects/6/statuses/7d938cb8ac15788d71f4b67c035515a160ea76d8", 'project_update_commit_status').
        with(query: { name: 'test', ref: 'decreased-spec', state: 'failed' })
      @status = Gitlab.update_commit_status(6, '7d938cb8ac15788d71f4b67c035515a160ea76d8', 'failed', name: 'test', ref: 'decreased-spec')
    end

    it "should get the correct resource" do
      expect(a_post('/projects/6/statuses/7d938cb8ac15788d71f4b67c035515a160ea76d8').
        with(query: { name: 'test', ref: 'decreased-spec', state: 'failed' }))
    end

    it "should information about the newly created status" do
      expect(@status).to be_kind_of Gitlab::ObjectifiedHash
      expect(@status.id).to eq(498)
      expect(@status.sha).to eq('7d938cb8ac15788d71f4b67c035515a160ea76d8')
      expect(@status.status).to eq('failed')
      expect(@status.ref).to eq('decreased-spec')
    end
  end
end
