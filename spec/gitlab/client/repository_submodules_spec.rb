# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.edit_submodule' do
    let(:api_path) { '/projects/3/repository/submodules/submodule' }
    let(:options) do
      {
        branch: 'branch',
        commit_sha: '3ddec28ea23acc5caa5d8331a6ecb2a65fc03e88',
        commit_message: 'commit message'
      }
    end

    before do
      stub_put(api_path, 'repository_submodule')
      @submodule = Gitlab.edit_submodule(3, 'submodule', options)
    end

    it 'updates the correct resource' do
      expect(a_put(api_path).with(body: hash_including(options))).to have_been_made
    end

    it 'returns information about the updated submodule' do
      expect(@submodule.short_id).to eq 'ed899a2f4b5'
      expect(@submodule.status).to be_nil
    end
  end
end
