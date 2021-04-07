# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.epic_issues' do
    before do
      stub_get('/groups/7/epics/3/issues', 'epic_issues')
      @issues = Gitlab.epic_issues(7, 3)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/7/epics/3/issues')).to have_been_made
    end

    it "returns a paginated response of project's issues" do
      expect(@issues).to be_a Gitlab::PaginatedResponse
      expect(@issues.first.epic.group_id).to eq(7)
      expect(@issues.first.epic.iid).to eq(3)
      expect(@issues.first.epic_iid).to eq(3)
    end
  end
end
