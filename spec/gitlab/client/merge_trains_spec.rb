# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.merge_trains' do
    before do
      stub_get('/projects/3/merge_trains', 'merge_trains')
      @merge_trains = Gitlab.merge_trains(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_trains')).to have_been_made
    end

    it 'returns a paginated response of mrege trains' do
      expect(@merge_trains).to be_a Gitlab::PaginatedResponse
      expect(@merge_trains.first.target_branch).to eq('feature-1580973432')
    end
  end

  describe '.merge_train_merge_requests' do
    before do
      stub_get('/projects/3/merge_trains/main', 'merge_train_merge_requests')
      @merge_train_merge_requests = Gitlab.merge_train_merge_requests(3, 'main')
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_trains/main')).to have_been_made
    end

    it 'returns a paginated response of merge train merge requests' do
      expect(@merge_train_merge_requests).to be_a Gitlab::PaginatedResponse
      expect(@merge_train_merge_requests.first.id).to eq(267)
    end
  end

  describe '.merge_train_status' do
    before do
      stub_get('/projects/3/merge_trains/merge_requests/1', 'merge_train_status')
      @merge_train_status = Gitlab.merge_train_status(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/merge_trains/merge_requests/1')).to have_been_made
    end

    it 'returns merge train status' do
      expect(@merge_train_status).to be_a Gitlab::ObjectifiedHash
      expect(@merge_train_status.id).to eq(267)
    end
  end

  describe '.add_merge_request_to_merge_train' do
    before do
      stub_post('/projects/3/merge_trains/merge_requests/1', 'add_mr_to_merge_train')
      @merge_train_status = Gitlab.add_merge_request_to_merge_train(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/merge_trains/merge_requests/1')).to have_been_made
    end

    it 'adds merge request to merge train and returns merge trains' do
      expect(@merge_train_status).to be_a Gitlab::PaginatedResponse
      expect(@merge_train_status.first.id).to eq(267)
    end
  end
end
