# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.project_merge_request_approvals' do
    before do
      stub_get('/projects/1/approvals', 'project_merge_request_approvals')
      @project_mr_approvals = Gitlab.project_merge_request_approvals(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/approvals')).to have_been_made
    end

    it 'returns the correct objectified hash' do
      expect(@project_mr_approvals).to be_a Gitlab::ObjectifiedHash
    end
  end

  describe '.edit_project_merge_request_approvals' do
    before do
      body = { approvals_before_merge: '3', reset_approvals_on_push: 'false', disable_overriding_approvers_per_merge_request: 'true' }
      stub_post('/projects/1/approvers', 'project_merge_request_approvals').with(body: body)
      @project_mr_approvals = Gitlab.edit_project_merge_request_approvals(1, approvals_before_merge: 3, reset_approvals_on_push: false, disable_overriding_approvers_per_merge_request: true)
    end

    it 'gets the correct resource' do
      body = { approvals_before_merge: '3', reset_approvals_on_push: 'false', disable_overriding_approvers_per_merge_request: 'true' }
      expect(a_post('/projects/1/approvers')
        .with(body: body)).to have_been_made
    end

    it 'returns the correct updated configuration' do
      expect(@project_mr_approvals).to be_a Gitlab::ObjectifiedHash
      expect(@project_mr_approvals.approvals_before_merge).to eq 3
      expect(@project_mr_approvals.reset_approvals_on_push).to eq false
      expect(@project_mr_approvals.disable_overriding_approvers_per_merge_request).to eq true
    end
  end

  describe '.edit_project_approvers' do
    before do
      body = { "approver_ids": ['5'], "approver_group_ids": ['1'] }
      stub_put('/projects/1/approvals', 'project_merge_request_approvals').with(body: body)
      @project_mr_approvals = Gitlab.edit_project_approvers(1, approver_ids: [5], approver_group_ids: [1])
    end

    it 'gets the correct resource' do
      body = { "approver_ids": ['5'], "approver_group_ids": ['1'] }
      expect(a_put('/projects/1/approvals')
        .with(body: body)).to have_been_made
    end

    it 'returns the correct updated configuration' do
      expect(@project_mr_approvals).to be_a Gitlab::ObjectifiedHash
      expect(@project_mr_approvals.approvers.map { |approver| approver['user']['id'] }).to eq [5]
      expect(@project_mr_approvals.approver_groups.map { |approver_group| approver_group['group']['id'] }).to eq [1]
    end
  end

  describe '.merge_request_approvals' do
    before do
      stub_get('/projects/1/merge_requests/5/approvals', 'merge_request_approvals')
      @merge_request_approvals = Gitlab.merge_request_approvals(1, 5)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/merge_requests/5/approvals')).to have_been_made
    end

    it 'returns the correct objectified hash' do
      expect(@merge_request_approvals).to be_a Gitlab::ObjectifiedHash
      expect(@merge_request_approvals.project_id).to eq 1
      expect(@merge_request_approvals.iid).to eq 5
    end
  end

  describe '.edit_merge_request_approvals' do
    before do
      body = { approvals_required: '2' }
      stub_post('/projects/1/merge_requests/5/approvals', 'merge_request_approvals').with(body: body)
      @merge_request_approvals = Gitlab.edit_merge_request_approvals(1, 5, approvals_required: 2)
    end

    it 'gets the correct resource' do
      body = { approvals_required: '2' }
      expect(a_post('/projects/1/merge_requests/5/approvals').with(body: body)).to have_been_made
    end

    it 'returns the correct objectified hash' do
      expect(@merge_request_approvals).to be_a Gitlab::ObjectifiedHash
      expect(@merge_request_approvals.approvals_required).to eq 2
    end
  end

  describe '.edit_merge_request_approvers' do
    before do
      body = { "approver_ids": ['1'], "approver_group_ids": ['5'] }
      stub_put('/projects/1/merge_requests/5/approvers', 'merge_request_approvals').with(body: body)
      @merge_request_approvals = Gitlab.edit_merge_request_approvers(1, 5, approver_ids: [1], approver_group_ids: [5])
    end

    it 'gets the correct resource' do
      body = { "approver_ids": ['1'], "approver_group_ids": ['5'] }
      expect(a_put('/projects/1/merge_requests/5/approvers')
        .with(body: body)).to have_been_made
    end

    it 'returns the correct updated configuration' do
      expect(@merge_request_approvals).to be_a Gitlab::ObjectifiedHash
      expect(@merge_request_approvals.approvers.map { |approver| approver['user']['id'] }).to eq [1]
      expect(@merge_request_approvals.approver_groups.map { |approver_group| approver_group['group']['id'] }).to eq [5]
    end
  end

  describe '.approve_merge_request' do
    before do
      stub_post('/projects/1/merge_requests/5/approve', 'merge_request_approvals')
      @merge_request_approvals = Gitlab.approve_merge_request(1, 5)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/1/merge_requests/5/approve')).to have_been_made
    end

    it 'returns the correct updated configuration' do
      expect(@merge_request_approvals).to be_a Gitlab::ObjectifiedHash
      expect(@merge_request_approvals.merge_status).to eq 'can_be_merged'
    end
  end

  describe '.unapprove_merge_request' do
    before do
      stub_post('/projects/1/merge_requests/5/unapprove', 'merge_request_approvals')
      @merge_request_approvals = Gitlab.unapprove_merge_request(1, 5)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/1/merge_requests/5/unapprove')).to have_been_made
    end
  end
end
