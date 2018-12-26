# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.edit_submodule' do
    let(:api_path) { '/projects/3/repository/submodules/submodule' }
    let!(:request_stub) { stub_put(api_path, 'repository_submodule') }
    let!(:submodule) { Gitlab.edit_submodule(3, 'submodule', 'branch', '3ddec28ea23acc5caa5d8331a6ecb2a65fc03e88', 'commit message') }

    it 'updates the correct resource' do
      expected_parameters = {
        branch: 'branch',
        commit_sha: '3ddec28ea23acc5caa5d8331a6ecb2a65fc03e88',
        commit_message: 'commit message'
      }
      expect(a_put(api_path).with(body: hash_including(expected_parameters))).to have_been_made
    end

    # Nothing to test on the answer data yet...
    # it 'returns information about the new submodule' do
    #   expect(submodule.submodule).to eq 'submodule'
    #   expect(submodule.branch_name).to eq 'branch'
    # end
  end
end
