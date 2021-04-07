# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.version' do
    before do
      stub_get('/version', 'version')
    end

    let!(:version) { Gitlab.version }

    it 'gets the correct resource' do
      expect(a_get('/version')).to have_been_made
    end

    it 'returns information about gitlab server' do
      expect(version.version).to eq('8.13.0-pre')
      expect(version.revision).to eq('4e963fe')
    end
  end
end
