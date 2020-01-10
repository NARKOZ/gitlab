# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.approval_settings_for_project' do
    before do
      stub_get('/projects/1/approval_settings', 'approval_settings')
      @project_rules = Gitlab.approval_settings_for_project(1)
    end

    it 'gets the project approval settings' do
      expect(a_get('/projects/1/approval_settings')).to have_been_made
    end

    it 'gets the correct approval settings' do
      expect(@project_rules).to be_a Gitlab::ObjectifiedHash
    end
  end
end
