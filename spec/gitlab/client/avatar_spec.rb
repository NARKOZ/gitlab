# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.avatar' do
    before do
      stub_get('/avatar', 'avatar').with(query: { email: 'admin@example.com', size: 32 })
      @avatar = Gitlab.avatar(email: 'admin@example.com', size: 32)
    end

    it 'gets the correct resource' do
      expect(a_get('/avatar')
        .with(query: { email: 'admin@example.com', size: 32 })).to have_been_made
    end
  end
end
