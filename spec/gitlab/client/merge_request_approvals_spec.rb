# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
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
      stub_post('/projects/1/approvals', 'project_merge_request_approvals').with(body: body)
      @project_mr_approvals = Gitlab.edit_project_merge_request_approvals(1, approvals_before_merge: 3, reset_approvals_on_push: false, disable_overriding_approvers_per_merge_request: true)
    end

    it 'gets the correct resource' do
      body = { approvals_before_merge: '3', reset_approvals_on_push: 'false', disable_overriding_approvers_per_merge_request: 'true' }
      expect(a_post('/projects/1/approvals')
        .with(body: body)).to have_been_made
    end

    it 'returns the correct updated configuration' do
      expect(@project_mr_approvals).to be_a Gitlab::ObjectifiedHash
      expect(@project_mr_approvals.approvals_before_merge).to eq 3
      expect(@project_mr_approvals.reset_approvals_on_push).to eq false
      expect(@project_mr_approvals.disable_overriding_approvers_per_merge_request).to eq true
    end
  end

  describe '.project_merge_request_approval_rules' do
    before do
      stub_get('/projects/1/approval_rules', 'project_merge_request_approval_rules')
      @project_mr_approval_rules = Gitlab.project_merge_request_approval_rules(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/approval_rules')).to have_been_made
    end

    it 'returns the paginated list of approval rules' do
      expect(@project_mr_approval_rules).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.create_project_merge_request_approval_rule' do
    before do
      stub_post('/projects/1/approval_rules', 'project_merge_request_approval_rules')
      @project_mr_approval_rules = Gitlab.create_project_merge_request_approval_rule(1, name: 'security', approvals_required: 1)
    end

    it 'creates the correct resource' do
      expect(a_post('/projects/1/approval_rules')).to have_been_made
    end

    it 'returns the paginated list of approval rules' do
      expect(@project_mr_approval_rules).to be_a Gitlab::PaginatedResponse
      expect(@project_mr_approval_rules.first.id).to eq(1)
      expect(@project_mr_approval_rules.first.name).to eq('security')
      expect(@project_mr_approval_rules.first.approvals_required).to eq(3)
    end
  end

  describe '.update_project_merge_request_approval_rule' do
    before do
      stub_put('/projects/1/approval_rules/1', 'project_merge_request_approval_rules')
      @project_mr_approval_rules = Gitlab.update_project_merge_request_approval_rule(1, 1, name: 'security', approvals_required: 1)
    end

    it 'updates the correct resource' do
      expect(a_put('/projects/1/approval_rules/1')).to have_been_made
    end

    it 'returns the paginated list of approval rules' do
      expect(@project_mr_approval_rules).to be_a Gitlab::PaginatedResponse
      expect(@project_mr_approval_rules.first.id).to eq(1)
      expect(@project_mr_approval_rules.first.name).to eq('security')
      expect(@project_mr_approval_rules.first.approvals_required).to eq(3)
    end
  end

  describe '.delete_project_merge_request_approval_rule' do
    before do
      stub_delete('/projects/1/approval_rules/1', 'empty')
      Gitlab.delete_project_merge_request_approval_rule(1, 1)
    end

    it 'deletes the correct resource' do
      expect(a_delete('/projects/1/approval_rules/1')).to have_been_made
    end
  end

  describe '.edit_project_approvers' do
    before do
      body = { "approver_ids": ['5'], "approver_group_ids": ['1'] }
      stub_put('/projects/1/approvers', 'project_merge_request_approvals').with(body: body)
      @project_mr_approvals = Gitlab.edit_project_approvers(1, approver_ids: [5], approver_group_ids: [1])
    end

    it 'gets the correct resource' do
      body = { "approver_ids": ['5'], "approver_group_ids": ['1'] }
      expect(a_put('/projects/1/approvers')
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

  describe '.create_merge_request_level_rule' do
    before do
      body = { name: 'security', approvals_required: 1, approval_project_rule_id: 99, user_ids: [3, 4], group_ids: [5, 6] }
      stub_post('/projects/1/merge_requests/5/approval_rules', 'merge_request_level_rule').with(body: body)
      @merge_request_lvl_rule = Gitlab.create_merge_request_level_rule(1, 5, body)
    end

    it 'gets the correct resource' do
      body = { name: 'security', approvals_required: 1, approval_project_rule_id: 99, user_ids: [3, 4], group_ids: [5, 6] }
      expect(a_post('/projects/1/merge_requests/5/approval_rules')
               .with(body: body)).to have_been_made
    end

    it 'returns the correct updated configuration' do
      expect(@merge_request_lvl_rule).to be_a Gitlab::ObjectifiedHash
      expect(@merge_request_lvl_rule.name).to eq 'security'
      expect(@merge_request_lvl_rule.approvals_required).to eq 1
    end
  end

  describe '.merge_request_level_rule' do
    before do
      stub_get('/projects/3/merge_requests/1/approval_rules', 'merge_request_level_rule')
      @approval_state = Gitlab.merge_request_level_rule(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_requests/1/approval_rules')).to have_been_made
    end

    it 'returns information about all merge request level approval rules' do
      expect(@approval_state.approvals_required).to eq(1)
      expect(@approval_state.id).to eq(1)
    end
  end

  describe '.update_merge_request_level_rule' do
    before do
      body = { name: 'security', approvals_required: 1, user_ids: [3, 4], group_ids: [5, 6] }
      stub_put('/projects/1/merge_requests/5/approval_rules/69', 'merge_request_level_rule').with(body: body)
      @merge_request_lvl_rule = Gitlab.update_merge_request_level_rule(1, 5, 69, body)
    end

    it 'gets the correct resource' do
      body = { name: 'security', approvals_required: 1, user_ids: [3, 4], group_ids: [5, 6] }
      expect(a_put('/projects/1/merge_requests/5/approval_rules/69')
               .with(body: body)).to have_been_made
    end

    it 'returns the correct updated configuration' do
      expect(@merge_request_lvl_rule).to be_a Gitlab::ObjectifiedHash
      expect(@merge_request_lvl_rule.name).to eq 'security'
      expect(@merge_request_lvl_rule.approvals_required).to eq 1
    end
  end

  describe '.delete_merge_request_level_rule' do
    before do
      stub_delete('/projects/1/merge_requests/5/approval_rules/69', 'empty')
      Gitlab.delete_merge_request_level_rule(1, 5, 69)
    end

    it 'deletes the correct resource' do
      expect(a_delete('/projects/1/merge_requests/5/approval_rules/69')).to have_been_made
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

  describe '.merge_request_approval_state' do
    before do
      stub_get('/projects/3/merge_requests/1/approval_state', 'merge_request_approval_state')
      @approval_state = Gitlab.merge_request_approval_state(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_requests/1/approval_state')).to have_been_made
    end

    it 'returns information about all approval states of merge request' do
      expect(@approval_state.approvals_required).to eq(2)
      expect(@approval_state.approvals_left).to eq(2)
      expect(@approval_state.approved_by).to be_empty
    end
  end
end
