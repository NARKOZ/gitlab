# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.broadcast_messages' do
    before do
      stub_get('/broadcast_messages', 'broadcast_messages')
      @broadcast_messages = Gitlab.broadcast_messages
    end

    it 'gets the correct resource' do
      expect(a_get('/broadcast_messages')).to have_been_made
    end

    it 'returns a paginated response of broadcast messages' do
      expect(@broadcast_messages).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.broadcast_message' do
    before do
      stub_get('/broadcast_messages/1', 'broadcast_message')
      @broadcast_message = Gitlab.broadcast_message(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/broadcast_messages/1')).to have_been_made
    end

    it 'returns correct information about the broadcast message' do
      expect(@broadcast_message.id).to eq 1
    end
  end

  describe '.create_broadcast_message' do
    before do
      stub_post('/broadcast_messages', 'broadcast_message')
      @broadcast_message = Gitlab.create_broadcast_message('Deploy in progress', color: '#cecece')
    end

    it 'gets the correct resource' do
      expect(a_post('/broadcast_messages')
        .with(body: { message: 'Deploy in progress', color: '#cecece' })).to have_been_made
    end

    it 'returns correct information about the broadcast message created' do
      expect(@broadcast_message.message).to eq 'Deploy in progress'
      expect(@broadcast_message.color).to eq '#cecece'
    end
  end

  describe '.edit_broadcast_message' do
    before do
      stub_put('/broadcast_messages/1', 'broadcast_message')
      @broadcast_message = Gitlab.edit_broadcast_message(1, font: '#FFFFFF')
    end

    it 'gets the correct resource' do
      expect(a_put('/broadcast_messages/1')
        .with(body: { font: '#FFFFFF' })).to have_been_made
    end

    it 'returns correct information about the edited broadcast message' do
      expect(@broadcast_message.font).to eq '#FFFFFF'
    end
  end

  describe '.delete_broadcast_message' do
    before do
      stub_delete('/broadcast_messages/1', 'empty')
      @broadcast_message = Gitlab.delete_broadcast_message(1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/broadcast_messages/1')).to have_been_made
    end
  end
end
