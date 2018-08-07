# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.group_milestones' do
    before do
      stub_get('/groups/3/milestones', 'group_milestones')
      @milestones = Gitlab.group_milestones(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/milestones')).to have_been_made
    end

    it "returns a paginated response of group's milestones" do
      expect(@milestones).to be_a Gitlab::PaginatedResponse
      expect(@milestones.first.group_id).to eq(3)
    end
  end

  describe '.group_milestone' do
    before do
      stub_get('/groups/3/milestones/1', 'group_milestone')
      @milestone = Gitlab.group_milestone(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/milestones/1')).to have_been_made
    end

    it 'returns information about a milestone' do
      expect(@milestone.group_id).to eq(3)
    end
  end

  describe '.create_group_milestone' do
    before do
      stub_post('/groups/3/milestones', 'group_milestone')
      @milestone = Gitlab.create_group_milestone(3, 'title')
    end

    it 'gets the correct resource' do
      expect(a_post('/groups/3/milestones')
        .with(body: { title: 'title' })).to have_been_made
    end

    it 'returns information about a created milestone' do
      expect(@milestone.group_id).to eq(3)
    end
  end

  describe '.edit_group_milestone' do
    before do
      stub_put('/groups/3/milestones/33', 'group_milestone')
      @milestone = Gitlab.edit_group_milestone(3, 33, title: 'title')
    end

    it 'gets the correct resource' do
      expect(a_put('/groups/3/milestones/33')
        .with(body: { title: 'title' })).to have_been_made
    end

    it 'returns information about an edited milestone' do
      expect(@milestone.group_id).to eq(3)
    end
  end

  describe '.group_milestone_issues' do
    before do
      stub_get('/groups/3/milestones/1/issues', 'group_milestone_issues')
      @milestone_issues = Gitlab.group_milestone_issues(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/milestones/1/issues')).to have_been_made
    end

    it "returns a paginated response of milestone's issues" do
      expect(@milestone_issues).to be_a Gitlab::PaginatedResponse
      expect(@milestone_issues.first.milestone.id).to eq(1)
    end
  end

  describe '.group_milestone_merge_requests' do
    before do
      stub_get('/groups/3/milestones/1/merge_requests', 'group_milestone_merge_requests')
      @milestone_merge_requests = Gitlab.group_milestone_merge_requests(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/milestones/1/merge_requests')).to have_been_made
    end

    it "returns a paginated response of milestone's merge_requests" do
      expect(@milestone_merge_requests).to be_a Gitlab::PaginatedResponse
      expect(@milestone_merge_requests.first.milestone.id).to eq(1)
    end
  end
end
