# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.events' do
    before do
      stub_get('/events', 'user_events')
      @events = described_class.events
    end

    it 'gets the correct resource' do
      expect(a_get('/events')).to have_been_made
    end

    it "returns a response of user's events" do
      expect(@events).to be_a Gitlab::Client::PaginatedResponse
    end
  end

  describe '.user_events' do
    before do
      stub_get('/users/1/events', 'user_events')
      @events = described_class.user_events(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/users/1/events')).to have_been_made
    end

    it "returns a response of user's contribution events" do
      expect(@events).to be_a Gitlab::Client::PaginatedResponse
    end
  end

  describe '.project_events' do
    before do
      stub_get('/projects/1/events', 'project_events')
      @events = described_class.project_events(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/events')).to have_been_made
    end

    it "returns a response of project's visible events" do
      expect(@events).to be_a Gitlab::Client::PaginatedResponse
    end
  end
end
