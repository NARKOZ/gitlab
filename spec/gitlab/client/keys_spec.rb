# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.key' do
    before do
      stub_get('/keys/1', 'key')
      @key = Gitlab.key(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/keys/1')).to have_been_made
    end

    it 'returns information about a key' do
      expect(@key.id).to eq(1)
      expect(@key.title).to eq('narkoz@helium')
    end
  end

  describe '.key_by_fingerprint' do
    before do
      stub_get('/keys?fingerprint=9f:70:33:b3:50:4d:9a:a3:ef:ea:13:9b:87:0f:7f:7e', 'key')
      @key = Gitlab.key_by_fingerprint('9f:70:33:b3:50:4d:9a:a3:ef:ea:13:9b:87:0f:7f:7e')
    end

    it 'gets the correct resource' do
      expect(a_get('/keys?fingerprint=9f:70:33:b3:50:4d:9a:a3:ef:ea:13:9b:87:0f:7f:7e')).to have_been_made
    end

    it 'returns information about a key' do
      expect(@key.id).to eq(1)
      expect(@key.title).to eq('narkoz@helium')
    end
  end
end
