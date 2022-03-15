# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.user_merge_requests' do
    before do
      stub_get('/merge_requests', 'merge_requests')
      @user_merge_requests = Gitlab.user_merge_requests
    end

    it 'gets the correct resource' do
      expect(a_get('/merge_requests')).to have_been_made
    end

    it 'returns a paginated response of user merge requests' do
      expect(@user_merge_requests).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.merge_requests' do
    before do
      stub_get('/projects/3/merge_requests', 'merge_requests')
      @merge_requests = Gitlab.merge_requests(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_requests')).to have_been_made
    end

    it "returns a paginated response of project's merge requests" do
      expect(@merge_requests).to be_a Gitlab::PaginatedResponse
      expect(@merge_requests.first.project_id).to eq(3)
    end
  end

  describe '.merge_request' do
    before do
      stub_get('/projects/3/merge_requests/1', 'merge_request')
      @merge_request = Gitlab.merge_request(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_requests/1')).to have_been_made
    end

    it 'returns information about a merge request' do
      expect(@merge_request.project_id).to eq(3)
      expect(@merge_request.assignee.name).to eq('Jack Smith')
    end
  end

  describe '.merge_request_participants' do
    before do
      stub_get('/projects/3/merge_requests/1/participants', 'participants')
      Gitlab.merge_request_participants(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_requests/1/participants')).to have_been_made
    end
  end

  describe '.merge_request_pipelines' do
    before do
      stub_get('/projects/3/merge_requests/1/pipelines', 'pipelines')
      @pipelines = Gitlab.merge_request_pipelines(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_requests/1/pipelines')).to have_been_made
    end

    it 'returns information about all pipelines in merge request' do
      expect(@pipelines.first.id).to eq(47)
      expect(@pipelines.first.status).to eq('pending')
    end
  end

  describe '.create_merge_request_pipeline' do
    before do
      stub_post('/projects/3/merge_requests/2/pipelines', 'pipeline_create')
    end

    it 'returns information about created merge request pipeline' do
      @pipeline = Gitlab.create_merge_request_pipeline(3, 2)
      expect(@pipeline.yaml_errors).to be_nil
      expect(@pipeline.status).to eq('pending')
    end
  end

  describe '.create_merge_request' do
    before do
      stub_post('/projects/3/merge_requests', 'merge_request')
    end

    it 'returns information about a merge request' do
      @merge_request = Gitlab.create_merge_request(3, 'New feature',
                                                   source_branch: 'api',
                                                   target_branch: 'master')
      expect(@merge_request.project_id).to eq(3)
      expect(@merge_request.assignee.name).to eq('Jack Smith')
    end
  end

  describe '.update_merge_request' do
    before do
      stub_put('/projects/3/merge_requests/2', 'merge_request')
        .with(body: {
                assignee_id: '1',
                target_branch: 'master',
                title: 'A different new feature'
              })
      @merge_request = Gitlab.update_merge_request(3, 2,
                                                   assignee_id: '1',
                                                   target_branch: 'master',
                                                   title: 'A different new feature')
    end

    it 'gets the correct resource' do
      expect(a_put('/projects/3/merge_requests/2')
        .with(body: {
                assignee_id: '1',
                target_branch: 'master',
                title: 'A different new feature'
              })).to have_been_made
    end

    it 'returns information about a merge request' do
      expect(@merge_request.project_id).to eq(3)
      expect(@merge_request.assignee.name).to eq('Jack Smith')
    end
  end

  describe '.accept_merge_request' do
    before do
      stub_put('/projects/5/merge_requests/42/merge', 'merge_request')
        .with(body: { merge_commit_message: 'Nice!' })
      @merge_request = Gitlab.accept_merge_request(5, 42, merge_commit_message: 'Nice!')
    end

    it 'gets the correct resource' do
      expect(a_put('/projects/5/merge_requests/42/merge')
        .with(body: { merge_commit_message: 'Nice!' })).to have_been_made
    end

    it 'returns information about merged merge request' do
      expect(@merge_request.project_id).to eq(3)
      expect(@merge_request.assignee.name).to eq('Jack Smith')
    end
  end

  describe '.merge_request_comments' do
    before do
      stub_get('/projects/3/merge_requests/2/notes', 'merge_request_comments')
      @merge_request = Gitlab.merge_request_comments(3, 2)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_requests/2/notes')).to have_been_made
    end

    it "returns merge request's comments" do
      expect(@merge_request).to be_an Gitlab::PaginatedResponse
      expect(@merge_request.length).to eq(2)
      expect(@merge_request[0].note).to eq('this is the 1st comment on the 2merge merge request')
      expect(@merge_request[0].author.id).to eq(11)
      expect(@merge_request[1].note).to eq('another discussion point on the 2merge request')
      expect(@merge_request[1].author.id).to eq(12)
    end
  end

  describe '.create_merge_request_comment' do
    before do
      stub_post('/projects/3/merge_requests/2/notes', 'merge_request_comment')
      @merge_request = Gitlab.create_merge_request_comment(3, 2, 'Cool Merge Request!')
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/merge_requests/2/notes')).to have_been_made
    end

    it 'returns information about a merge request' do
      expect(@merge_request.note).to eq('Cool Merge Request!')
      expect(@merge_request.author.id).to eq(1)
    end
  end

  describe '.merge_request_changes' do
    before do
      stub_get('/projects/3/merge_requests/2/changes', 'merge_request_changes')
      @mr_changes = Gitlab.merge_request_changes(3, 2)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_requests/2/changes')).to have_been_made
    end

    it 'returns the merge request changes' do
      expect(@mr_changes.changes).to be_a Array
      expect(@mr_changes.changes.first['old_path']).to eq('lib/omniauth/builder.rb')
      expect(@mr_changes.id).to eq(2)
      expect(@mr_changes.project_id).to eq(3)
      expect(@mr_changes.source_branch).to eq('uncovered')
      expect(@mr_changes.target_branch).to eq('master')
    end
  end

  describe '.merge_request_commits' do
    before do
      stub_get('/projects/3/merge_requests/2/commits', 'merge_request_commits')
      @mr_commits = Gitlab.merge_request_commits(3, 2)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_requests/2/commits')).to have_been_made
    end

    it 'returns the merge request commits' do
      expect(@mr_commits).to be_a Gitlab::PaginatedResponse
      expect(@mr_commits.size).to eq 2
      expect(@mr_commits.first.id).to eq 'a2da7552f26d5b46a6a09bb8b7b066e3a102be7d'
      expect(@mr_commits.first.short_id).to eq 'a2da7552'
      expect(@mr_commits.first.title).to eq 'piyo'
      expect(@mr_commits.first.author_name).to eq 'example'
      expect(@mr_commits.first.author_email).to eq 'example@example.com'
      expect(@mr_commits[1].short_id).to eq '3ce50959'
      expect(@mr_commits[1].title).to eq 'hoge'
    end
  end

  describe '.merge_request_closes_issues' do
    before do
      stub_get('/projects/5/merge_requests/1/closes_issues', 'merge_request_closes_issues')
      @issues = Gitlab.merge_request_closes_issues(5, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/5/merge_requests/1/closes_issues')).to have_been_made
    end

    it 'returns a paginated response of the issues the merge_request will close' do
      expect(@issues).to be_a(Gitlab::PaginatedResponse)
      expect(@issues.first.title).to eq('Merge request 1 issue 1')
      expect(@issues.size).to eq(2)
    end
  end

  describe '.subscribe_to_merge_request' do
    before do
      stub_post('/projects/3/merge_requests/2/subscribe', 'merge_request')
      @merge_request = Gitlab.subscribe_to_merge_request(3, 2)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/merge_requests/2/subscribe')).to have_been_made
    end

    it 'returns information about a merge request' do
      expect(@merge_request.project_id).to eq(3)
    end
  end

  describe '.unsubscribe_from_merge_request' do
    before do
      stub_post('/projects/3/merge_requests/2/unsubscribe', 'merge_request')
      @merge_request = Gitlab.unsubscribe_from_merge_request(3, 2)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/merge_requests/2/unsubscribe')).to have_been_made
    end

    it 'returns information about a merge request' do
      expect(@merge_request.project_id).to eq(3)
    end
  end

  describe '.merge_request_discussions' do
    before do
      stub_get('/projects/3/merge_requests/2/discussions', 'merge_request_discussions')
      @discussions = Gitlab.merge_request_discussions(3, 2)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_requests/2/discussions')).to have_been_made
    end

    it 'returns information about the discussions' do
      expect(@discussions.length).to eq(1)
      expect(@discussions.first.id).to eq('7d66bf19bf835e6a4666130544ba1b5c343fc705')
    end
  end

  describe '.merge_request_discussion' do
    before do
      stub_get('/projects/3/merge_requests/2/discussions/1', 'merge_request_discussion')
      @discussion = Gitlab.merge_request_discussion(3, 2, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_requests/2/discussions/1')).to have_been_made
    end

    it 'returns information about the discussions' do
      expect(@discussion.id).to eq('7d66bf19bf835e6a4666130544ba1b5c343fc705')
    end
  end

  describe '.create_merge_request_discussion' do
    before do
      stub_post('/projects/3/merge_requests/2/discussions', 'merge_request_discussion')
      @discussion = Gitlab.create_merge_request_discussion(3, 2, body: 'Discussion', position: { old_line: 1 })
    end

    it 'posts the correct resource' do
      expect(a_post('/projects/3/merge_requests/2/discussions')
        .with(body: 'body=Discussion&position[old_line]=1'.gsub('[', '%5B').gsub(']', '%5D'))).to have_been_made
    end

    it 'returns information about the discussions' do
      expect(@discussion.id).to eq('7d66bf19bf835e6a4666130544ba1b5c343fc705')
    end
  end

  describe '.resolve_merge_request_discussion' do
    before do
      stub_put('/projects/3/merge_requests/2/discussions/1', 'merge_request_discussion')
      @discussion = Gitlab.resolve_merge_request_discussion(3, 2, 1, resolved: true)
    end

    it 'puts the correct resource' do
      expect(a_put('/projects/3/merge_requests/2/discussions/1')
             .with(body: 'resolved=true')).to have_been_made
    end

    it 'returns information about the discussions' do
      expect(@discussion.id).to eq('7d66bf19bf835e6a4666130544ba1b5c343fc705')
      note = @discussion.notes.first
      expect(note['id']).to eq(1758)
    end
  end

  describe '.create_merge_request_discussion_note' do
    before do
      stub_post('/projects/3/merge_requests/2/discussions/1/notes', 'merge_request_discussion_note')
      @note = Gitlab.create_merge_request_discussion_note(3, 2, 1, body: 'note')
    end

    it 'posts the correct resource' do
      expect(a_post('/projects/3/merge_requests/2/discussions/1/notes')
             .with(body: 'body=note')).to have_been_made
    end

    it 'returns information about the note' do
      expect(@note.id).to eq(1775)
    end
  end

  describe '.update_merge_request_discussion_note' do
    before do
      stub_put('/projects/3/merge_requests/2/discussions/1/notes/1', 'merge_request_discussion_note')
      @note = Gitlab.update_merge_request_discussion_note(3, 2, 1, 1, body: 'note2')
    end

    it 'puts the correct resource' do
      expect(a_put('/projects/3/merge_requests/2/discussions/1/notes/1')
             .with(body: 'body=note2')).to have_been_made
    end

    it 'returns information about the note' do
      expect(@note.id).to eq(1775)
    end
  end

  describe '.delete_merge_request_discussion_note' do
    before do
      stub_request(:delete, 'https://api.example.com/projects/3/merge_requests/2/discussions/1/notes/1').to_return(body: '')
      @note = Gitlab.delete_merge_request_discussion_note(3, 2, 1, 1)
    end

    it 'deletes the correct resource' do
      expect(a_delete('/projects/3/merge_requests/2/discussions/1/notes/1')).to have_been_made
    end

    it 'returns nothing' do
      expect(@note).to be_falsy
    end
  end

  describe '.delete_merge_request' do
    before do
      stub_request(:delete, 'https://api.example.com/projects/3/merge_requests/2').to_return(body: '')
      @merge_request = Gitlab.delete_merge_request(3, 2)
    end

    it 'deletes the correct resource' do
      expect(a_delete('/projects/3/merge_requests/2')).to have_been_made
    end

    it 'returns nothing' do
      expect(@merge_request).to be_falsy
    end
  end

  describe '.merge_request_diff_versions' do
    before do
      stub_get('/projects/3/merge_requests/105/versions', 'merge_request_diff_versions')
      @versions = Gitlab.merge_request_diff_versions(3, 105)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_requests/105/versions')).to have_been_made
    end

    it 'returns an array of the versions' do
      expect(@versions.length).to eq(2)
      expect(@versions.first.head_commit_sha).to eq('33e2ee8579fda5bc36accc9c6fbd0b4fefda9e30')
    end
  end

  describe '.merge_request_diff_version' do
    before do
      stub_get('/projects/3/merge_requests/105/versions/1', 'merge_request_diff_version')
      @diff = Gitlab.merge_request_diff_version(3, 105, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_requests/105/versions/1')).to have_been_made
    end

    it 'returns diff, with array of diffs in version' do
      expect(@diff.diffs).to be_a Array
      expect(@diff.diffs.first['old_path']).to eq('LICENSE')
    end
  end

  describe '.rebase_merge_request' do
    before do
      stub_put('/projects/3/merge_requests/105/rebase', 'merge_request_rebase')
        .with(body: { skip_ci: true })
      @response = Gitlab.rebase_merge_request(3, 105, skip_ci: true)
    end

    it 'gets correct resource' do
      expect(a_put('/projects/3/merge_requests/105/rebase')
        .with(body: { skip_ci: true })).to have_been_made
    end

    it 'returns rebase in progress response' do
      expect(@response.rebase_in_progress).to be_truthy
    end
  end
end
