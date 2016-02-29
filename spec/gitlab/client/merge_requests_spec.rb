require 'spec_helper'

describe Gitlab::Client do
  describe ".merge_requests" do
    before do
      stub_get("/projects/3/merge_requests", "merge_requests")
      @merge_requests = Gitlab.merge_requests(3)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/merge_requests")).to have_been_made
    end

    it "should return a paginated response of project's merge requests" do
      expect(@merge_requests).to be_a Gitlab::PaginatedResponse
      expect(@merge_requests.first.project_id).to eq(3)
    end
  end

  describe ".merge_request" do
    before do
      stub_get("/projects/3/merge_request/1", "merge_request")
      @merge_request = Gitlab.merge_request(3, 1)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/merge_request/1")).to have_been_made
    end

    it "should return information about a merge request" do
      expect(@merge_request.project_id).to eq(3)
      expect(@merge_request.assignee.name).to eq("Jack Smith")
    end
  end

  describe ".create_merge_request" do
    before do
      stub_post("/projects/3/merge_requests", "merge_request")
    end

    it "should return information about a merge request" do
      @merge_request = Gitlab.create_merge_request(3, 'New feature',
                                                   source_branch: 'api',
                                                   target_branch: 'master'
                                                  )
      expect(@merge_request.project_id).to eq(3)
      expect(@merge_request.assignee.name).to eq("Jack Smith")
    end
  end

  describe ".update_merge_request" do
    before do
      stub_put("/projects/3/merge_request/2", "merge_request").
        with(body: {
               assignee_id: '1',
               target_branch: 'master',
               title: 'A different new feature'
             })
      @merge_request = Gitlab.update_merge_request(3, 2,
                                                   assignee_id: '1',
                                                   target_branch: 'master',
                                                   title: 'A different new feature'
                                                  )
    end

    it "should get the correct resource" do
      expect(a_put("/projects/3/merge_request/2").
        with(body: {
               assignee_id: '1',
               target_branch: 'master',
               title: 'A different new feature'
             })).to have_been_made
    end

    it "should return information about a merge request" do
      expect(@merge_request.project_id).to eq(3)
      expect(@merge_request.assignee.name).to eq("Jack Smith")
    end
  end

  describe ".accept_merge_request" do
    before do
      stub_put("/projects/5/merge_request/42/merge", "merge_request").
        with(body: { merge_commit_message: 'Nice!' })
      @merge_request = Gitlab.accept_merge_request(5, 42, merge_commit_message: 'Nice!')
    end

    it "should get the correct resource" do
      expect(a_put("/projects/5/merge_request/42/merge").
        with(body: { merge_commit_message: 'Nice!' })).to have_been_made
    end

    it "should return information about merged merge request" do
      expect(@merge_request.project_id).to eq(3)
      expect(@merge_request.assignee.name).to eq("Jack Smith")
    end
  end

  describe ".merge_request_comments" do
    before do
      stub_get("/projects/3/merge_requests/2/notes", "merge_request_comments")
      @merge_request = Gitlab.merge_request_comments(3, 2)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/merge_requests/2/notes")).to have_been_made
    end

    it "should return merge request's comments" do
      expect(@merge_request).to be_an Gitlab::PaginatedResponse
      expect(@merge_request.length).to eq(2)
      expect(@merge_request[0].note).to eq("this is the 1st comment on the 2merge merge request")
      expect(@merge_request[0].author.id).to eq(11)
      expect(@merge_request[1].note).to eq("another discussion point on the 2merge request")
      expect(@merge_request[1].author.id).to eq(12)
    end
  end

  describe ".create_merge_request_comment" do
    before do
      stub_post("/projects/3/merge_requests/2/notes", "merge_request_comment")
      @merge_request = Gitlab.create_merge_request_comment(3, 2, 'Cool Merge Request!')
    end

    it "should get the correct resource" do
      expect(a_post("/projects/3/merge_requests/2/notes")).to have_been_made
    end

    it "should return information about a merge request" do
      expect(@merge_request.note).to eq('Cool Merge Request!')
      expect(@merge_request.author.id).to eq(1)
    end
  end

  describe ".merge_request_changes" do
    before do
      stub_get("/projects/3/merge_request/2/changes", "merge_request_changes")
      @mr_changes = Gitlab.merge_request_changes(3, 2)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/merge_request/2/changes")).to have_been_made
    end

    it "should return the merge request changes" do
      expect(@mr_changes.changes).to be_a Array
      expect(@mr_changes.changes.first['old_path']).to eq('lib/omniauth/builder.rb')
      expect(@mr_changes.id).to eq(2)
      expect(@mr_changes.project_id).to eq(3)
      expect(@mr_changes.source_branch).to eq('uncovered')
      expect(@mr_changes.target_branch).to eq('master')
    end
  end

  describe ".merge_request_commits" do
    before do
      stub_get("/projects/3/merge_request/2/commits", "merge_request_commits")
      @mr_commits = Gitlab.merge_request_commits(3, 2)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/merge_request/2/commits")).to have_been_made
    end

    it "should return the merge request commits" do
      expect(@mr_commits).to be_a Gitlab::PaginatedResponse
      expect(@mr_commits.size).to eq 2
      expect(@mr_commits.first.id).to eq "a2da7552f26d5b46a6a09bb8b7b066e3a102be7d"
      expect(@mr_commits.first.short_id).to eq "a2da7552"
      expect(@mr_commits.first.title).to eq "piyo"
      expect(@mr_commits.first.author_name).to eq "example"
      expect(@mr_commits.first.author_email).to eq "example@example.com"
      expect(@mr_commits[1].short_id).to eq "3ce50959"
      expect(@mr_commits[1].title).to eq "hoge"
    end
  end
end
