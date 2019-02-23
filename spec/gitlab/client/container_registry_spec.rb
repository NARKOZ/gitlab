# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.registry_repositories' do
    before do
      stub_get('/projects/3/registry/repositories', 'registry_repositories')
      @registry_repositories = Gitlab.registry_repositories(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/registry/repositories')).to have_been_made
    end

    it "returns a paginated response of project's registry repositories" do
      expect(@registry_repositories).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.delete_registry_repository' do
    before do
      stub_delete('/projects/3/registry/repositories/1', 'empty')
      Gitlab.delete_registry_repository(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/3/registry/repositories/1')).to have_been_made
    end
  end

  describe '.registry_repository_tags' do
    before do
      stub_get('/projects/3/registry/repositories/1/tags', 'registry_repository_tags')
      @registry_repository_tags = Gitlab.registry_repository_tags(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/registry/repositories/1/tags')).to have_been_made
    end

    it "returns a paginated response of a registry repository's tags" do
      expect(@registry_repository_tags).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.registry_repository_tag' do
    before do
      stub_get('/projects/3/registry/repositories/1/tags/v10.0.0', 'registry_repository_tag')
      @registry_repository_tag = Gitlab.registry_repository_tag(3, 1, 'v10.0.0')
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/registry/repositories/1/tags/v10.0.0')).to have_been_made
    end

    it 'returns correct information about the registry repository tag' do
      expect(@registry_repository_tag.name).to eq 'v10.0.0'
    end
  end

  describe '.delete_registry_repository_tag' do
    before do
      stub_delete('/projects/3/registry/repositories/1/tags/v10.0.0', 'empty')
      Gitlab.delete_registry_repository_tag(3, 1, 'v10.0.0')
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/3/registry/repositories/1/tags/v10.0.0')).to have_been_made
    end
  end

  describe '.bulk_delete_registry_repository_tags' do
    context 'when just name_regex provided for deletion' do
      before do
        stub_delete('/projects/3/registry/repositories/1/tags', 'empty').with(query: { name_regex: '.*' })
        Gitlab.bulk_delete_registry_repository_tags(3, 1, name_regex: '.*')
      end

      it 'gets the correct resource' do
        expect(a_delete('/projects/3/registry/repositories/1/tags')
          .with(query: { name_regex: '.*' })).to have_been_made
      end
    end
    context 'when all options provided for deletion' do
      before do
        stub_delete('/projects/3/registry/repositories/1/tags', 'empty').with(query: { name_regex: '[0-9a-z]{40}', keep_n: 5, older_than: '1d' })
        Gitlab.bulk_delete_registry_repository_tags(3, 1, name_regex: '[0-9a-z]{40}', keep_n: 5, older_than: '1d')
      end

      it 'gets the correct resource' do
        expect(a_delete('/projects/3/registry/repositories/1/tags')
          .with(query: { name_regex: '[0-9a-z]{40}', keep_n: 5, older_than: '1d' })).to have_been_made
      end
    end
  end
end
