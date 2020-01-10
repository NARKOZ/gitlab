# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.delete_approval_rule' do
    before do
      stub_delete('/projects/1/approval_settings/rules/1', 'approval_rules')
      @project_rules = Gitlab.delete_approval_rule(1,1)
    end

    it 'deletes the correct rule' do
      expect(a_delete('/projects/1/approval_settings/rules/1')).to have_been_made
    end

  end

  describe '.create_approval_rule' do
    context 'without external_url' do
      before do
        stub_post('/projects/1/approval_settings/rules', 'approval_rules')
        @project_rules = Gitlab.create_approval_rule(1, 'Default', approvals_required: 2, users: [], groups: [1,2], remove_hidden_groups: false)
      end

      it 'creates the correct rule' do
        expect(a_post('/projects/1/approval_settings/rules')).to have_been_made
      end
    end
  end
end
