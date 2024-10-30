# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.remote_mirrors' do
    before do
      stub_get('/projects/5/remote_mirrors', 'remote_mirrors')
      @mirrors = Gitlab.remote_mirrors(5)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/5/remote_mirrors')).to have_been_made
    end

    it "returns a paginated response of project's push mirrors" do
      expect(@mirrors).to be_an Gitlab::PaginatedResponse
      expect(@mirrors.first).to be_a Gitlab::ObjectifiedHash
      expect(@mirrors.first.enabled).to be(true)
    end
  end

  describe '.remote_mirror' do
    before do
      stub_get('/projects/5/remote_mirrors/123456', 'remote_mirror')
      @mirror = Gitlab.remote_mirror(5, 123_456)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/5/remote_mirrors/123456')).to have_been_made
    end

    it "returns a paginated response of project's push mirrors" do
      expect(@mirror).to be_a Gitlab::ObjectifiedHash
      expect(@mirror.enabled).to be(true)
      expect(@mirror.url).to include('gitlab.com/mirror/target.git')
    end
  end

  describe '.create_remote_mirror' do
    let(:api_path) { '/projects/5/remote_mirrors' }
    let(:mirror_path) { 'https://username:token@example.com/gitlab/example.git' }

    before do
      stub_post(api_path, 'remote_mirror_create')
      @mirror = Gitlab.create_remote_mirror(5, mirror_path, enabled: false)
    end

    it 'posts to the correct resource' do
      expect(a_post(api_path).with(body: { url: mirror_path, enabled: false }))
        .to have_been_made
    end

    it 'returns a single remote mirror' do
      expect(@mirror).to be_a Gitlab::ObjectifiedHash
      expect(@mirror.enabled).to be(false)
      expect(@mirror.id).to eq(123_456)
      expect(@mirror.url).to include('example.com/gitlab/example.git')
    end
  end

  describe '.edit_remote_mirror' do
    let(:api_path) { '/projects/5/remote_mirrors/123456' }

    before do
      stub_put(api_path, 'remote_mirror_edit')
      @mirror = Gitlab.edit_remote_mirror(
        5,
        123_456,
        only_protected_branches: true,
        keep_divergent_refs: true
      )
    end

    it 'puts to the correct resource' do
      expect(a_put(api_path).with(body: { only_protected_branches: true, keep_divergent_refs: true }))
        .to have_been_made
    end

    it 'returns a single remote mirror' do
      expect(@mirror).to be_a Gitlab::ObjectifiedHash
      expect(@mirror.enabled).to be(false)
      expect(@mirror.only_protected_branches).to be(true)
      expect(@mirror.keep_divergent_refs).to be(true)
    end
  end

  describe '.delete_remote_mirror' do
    before do
      stub_request(:delete, "#{Gitlab.endpoint}/projects/5/remote_mirrors/123456")
        .with(headers: { 'PRIVATE-TOKEN' => Gitlab.private_token })
        .to_return(status: 204)
      @mirror = Gitlab.delete_remote_mirror(5, 123_456)
    end

    it 'deletes the correct resource' do
      expect(a_delete('/projects/5/remote_mirrors/123456')).to have_been_made
    end

    it 'removes the mirror' do
      expect(@mirror.to_h).to be_empty
    end
  end

  describe '.sync_remote_mirror' do
    before do
      stub_request(:post, "#{Gitlab.endpoint}/projects/5/remote_mirrors/123456/sync")
        .with(headers: { 'PRIVATE-TOKEN' => Gitlab.private_token })
        .to_return(status: 204)
      @mirror = Gitlab.sync_remote_mirror(5, 123_456)
    end

    it 'executes a POST to the correct resource' do
      expect(a_post('/projects/5/remote_mirrors/123456/sync')).to have_been_made
    end
  end
end
