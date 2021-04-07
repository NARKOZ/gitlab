# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.issue_state_events' do
    before do
      stub_get('/projects/5/issues/42/resource_state_events', 'issue_resource_state_events')
      @events = Gitlab.issue_state_events(5, 42)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/5/issues/42/resource_state_events')).to have_been_made
    end

    it "returns a paginated response of project's issue's state events" do
      expect(@events).to be_a Gitlab::PaginatedResponse
      expect(@events.first.id).to eq(142)
    end
  end

  describe '.issue_state_event' do
    before do
      stub_get('/projects/5/issues/42/resource_state_events/142', 'issue_resource_state_event')
      @event = Gitlab.issue_state_event(5, 42, 142)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/5/issues/42/resource_state_events/142')).to have_been_made
    end

    it "returns a paginated response of project's issue's state event" do
      expect(@event).to be_a Gitlab::ObjectifiedHash
      expect(@event.user.name).to eq('Administrator')
    end
  end

  describe '.merge_request_state_events' do
    before do
      stub_get('/projects/5/merge_requests/42/resource_state_events', 'mr_resource_state_events')
      @events = Gitlab.merge_request_state_events(5, 42)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/5/merge_requests/42/resource_state_events')).to have_been_made
    end

    it "returns a paginated response of project's merge request's state events" do
      expect(@events).to be_a Gitlab::PaginatedResponse
      expect(@events.first.id).to eq(142)
    end
  end

  describe '.merge_request_state_event' do
    before do
      stub_get('/projects/5/merge_requests/42/resource_state_events/142', 'mr_resource_state_event')
      @event = Gitlab.merge_request_state_event(5, 42, 142)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/5/merge_requests/42/resource_state_events/142')).to have_been_made
    end

    it "returns a paginated response of project's merge request's state event" do
      expect(@event).to be_a Gitlab::ObjectifiedHash
      expect(@event.user.name).to eq('Administrator')
    end
  end
end
