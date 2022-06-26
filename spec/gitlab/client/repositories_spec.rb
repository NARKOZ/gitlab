# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  it { is_expected.to respond_to :repo_tags }
  it { is_expected.to respond_to :repo_create_tag }
  it { is_expected.to respond_to :repo_branches }
  it { is_expected.to respond_to :repo_branch }
  it { is_expected.to respond_to :repo_tree }
  it { is_expected.to respond_to :repo_compare }
  it { is_expected.to respond_to :repo_contributors }

  describe '.tags' do
    before do
      stub_get('/projects/3/repository/tags', 'project_tags')
      @tags = Gitlab.tags(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/repository/tags')).to have_been_made
    end

    it 'returns a paginated response of repository tags' do
      expect(@tags).to be_a Gitlab::PaginatedResponse
      expect(@tags.first.name).to eq('v2.8.2')
    end
  end

  describe '.create_tag' do
    context 'when lightweight' do
      before do
        stub_post('/projects/3/repository/tags', 'project_tag_lightweight')
        @tag = Gitlab.create_tag(3, 'v1.0.0', '2695effb5807a22ff3d138d593fd856244e155e7')
      end

      it 'gets the correct resource' do
        expect(a_post('/projects/3/repository/tags')).to have_been_made
      end

      it 'returns information about a new repository tag' do
        expect(@tag.name).to eq('v1.0.0')
        expect(@tag.message).to eq(nil)
      end
    end

    context 'when annotated' do
      before do
        stub_post('/projects/3/repository/tags', 'project_tag_annotated')
        @tag = Gitlab.create_tag(3, 'v1.1.0', '2695effb5807a22ff3d138d593fd856244e155e7', 'Release 1.1.0')
      end

      it 'gets the correct resource' do
        expect(a_post('/projects/3/repository/tags')).to have_been_made
      end

      it 'returns information about a new repository tag' do
        expect(@tag.name).to eq('v1.1.0')
        expect(@tag.message).to eq('Release 1.1.0')
      end
    end
  end

  describe '.tree' do
    before do
      stub_get('/projects/3/repository/tree', 'tree')
      @tree = Gitlab.tree(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/repository/tree')).to have_been_made
    end

    it 'returns a paginated response of repository tree files (root level)' do
      expect(@tree).to be_a Gitlab::PaginatedResponse
      expect(@tree.first.name).to eq('app')
    end
  end

  describe '.compare' do
    before do
      stub_get('/projects/3/repository/compare', 'compare_merge_request_diff')
        .with(query: { from: 'master', to: 'feature' })
      @diff = Gitlab.compare(3, 'master', 'feature')
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/repository/compare')
        .with(query: { from: 'master', to: 'feature' })).to have_been_made
    end

    it 'gets diffs of a merge request' do
      expect(@diff.diffs).to be_kind_of Array
      expect(@diff.diffs.last['new_path']).to eq 'files/js/application.js'
    end
  end

  describe '.merge_base' do
    before do
      stub_get('/projects/3/repository/merge_base', 'merge_base')
        .with(query: { refs: %w[master feature] })
      @response = Gitlab.merge_base(3, %w[master feature])
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/repository/merge_base')
        .with(query: { refs: %w[master feature] })).to have_been_made
    end

    it 'gets common ancestor of the two refs' do
      expect(@response).to be_kind_of Gitlab::ObjectifiedHash
      expect(@response.id).to eq '1a0b36b3cdad1d2ee32457c102a8c0b7056fa863'
    end
  end

  describe '.contributors' do
    before do
      stub_get('/projects/3/repository/contributors', 'contributors')
      @contributors = Gitlab.contributors(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/repository/contributors')).to have_been_made
    end

    it 'returns a paginated response of repository contributors' do
      expect(@contributors).to be_a Gitlab::PaginatedResponse
      expect(@contributors.first.name).to eq('Dmitriy Zaporozhets')
      expect(@contributors.first.commits).to eq(117)
    end
  end

  describe '.generate_changelog' do
    before do
      stub_post('/projects/3/repository/changelog', 'generate_changelog')
        .with(body: { version: 'v1.0.0', branch: 'main' })
      @changelog = Gitlab.generate_changelog(3, 'v1.0.0', branch: 'main')
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/repository/changelog')
        .with(body: { version: 'v1.0.0', branch: 'main' })).to have_been_made
    end

    it 'returns successful result' do
      expect(@changelog).to be_truthy
    end
  end

  describe '.get_changelog' do
    before do
      stub_get('/projects/3/repository/changelog', 'changelog')
        .with(body: { version: 'v1.0.0' })
      @changelog = Gitlab.get_changelog(3, 'v1.0.0')
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/repository/changelog')
        .with(body: { version: 'v1.0.0' })).to have_been_made
    end

    it 'returns changelog notes' do
      expect(@changelog).to be_kind_of Gitlab::ObjectifiedHash
      expect(@changelog.notes).to be_a String
    end
  end
end
