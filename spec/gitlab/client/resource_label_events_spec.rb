# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.issue_label_events' do
    before do
      stub_get('/projects/5/issues/42/resource_label_events', 'resource_label_events')
      @events = Gitlab.issue_label_events(5, 42)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/5/issues/42/resource_label_events')).to have_been_made
    end

    it "returns a paginated response of project's issue's label events" do
      expect(@events).to be_a Gitlab::PaginatedResponse
      expect(@events.first.id).to eq(142)
    end
  end

  describe '.issue_label_event' do
    before do
      stub_get('/projects/5/issues/42/resource_label_events/142', 'resource_label_event')
      @event = Gitlab.issue_label_event(5, 42, 142)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/5/issues/42/resource_label_events/142')).to have_been_made
    end

    it "returns a paginated response of project's issue's label event" do
      expect(@event).to be_a Gitlab::ObjectifiedHash
      expect(@event.user.name).to eq('Administrator')
    end
  end

  describe '.epic_label_events' do
    before do
      stub_get('/groups/5/epics/42/resource_label_events', 'resource_label_events')
      @events = Gitlab.epic_label_events(5, 42)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/5/epics/42/resource_label_events')).to have_been_made
    end

    it "returns a paginated response of project's epic's label events" do
      expect(@events).to be_a Gitlab::PaginatedResponse
      expect(@events.first.id).to eq(142)
    end
  end

  describe '.epic_label_event' do
    before do
      stub_get('/groups/5/epics/42/resource_label_events/142', 'resource_label_event')
      @event = Gitlab.epic_label_event(5, 42, 142)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/5/epics/42/resource_label_events/142')).to have_been_made
    end

    it "returns a paginated response of project's epic's label event" do
      expect(@event).to be_a Gitlab::ObjectifiedHash
      expect(@event.user.name).to eq('Administrator')
    end
  end

  describe '.merge_request_label_events' do
    before do
      stub_get('/projects/5/merge_requests/42/resource_label_events', 'resource_label_events')
      @events = Gitlab.merge_request_label_events(5, 42)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/5/merge_requests/42/resource_label_events')).to have_been_made
    end

    it "returns a paginated response of project's merge request's label events" do
      expect(@events).to be_a Gitlab::PaginatedResponse
      expect(@events.first.id).to eq(142)
    end
  end

  describe '.merge_request_label_event' do
    before do
      stub_get('/projects/5/merge_requests/42/resource_label_events/142', 'resource_label_event')
      @event = Gitlab.merge_request_label_event(5, 42, 142)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/5/merge_requests/42/resource_label_events/142')).to have_been_made
    end

    it "returns a paginated response of project's merge request's label event" do
      expect(@event).to be_a Gitlab::ObjectifiedHash
      expect(@event.user.name).to eq('Administrator')
    end
  end
end
