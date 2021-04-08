# frozen_string_literal: true

# rubocop:disable Style/FormatStringToken

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.project_badges' do
    before do
      stub_get('/projects/3/badges', 'project_badges')
      @project_badges = Gitlab.project_badges(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/badges')).to have_been_made
    end

    it "returns a paginated response of project's badges" do
      expect(@project_badges).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.project_badge' do
    before do
      stub_get('/projects/3/badges/3', 'project_badge')
      @project_badge = Gitlab.project_badge(3, 3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/badges/3')).to have_been_made
    end

    it 'returns information about a badge' do
      expect(@project_badge.id).to eq(1)
    end
  end

  describe '.add_project_badge' do
    before do
      stub_post('/projects/3/badges', 'project_badge')
      @project_badge = Gitlab.add_project_badge(3, link_url: 'http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}', image_url: 'https://shields.io/my/badge')
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/badges')
        .with(body: { link_url: 'http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}', image_url: 'https://shields.io/my/badge' })).to have_been_made
    end

    it 'returns information about an added project badge' do
      expect(@project_badge.link_url).to eq('http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}')
      expect(@project_badge.image_url).to eq('https://shields.io/my/badge')
    end
  end

  describe '.edit_project_badge' do
    before do
      stub_put('/projects/3/badges/1', 'project_badge')
      @project_badge = Gitlab.edit_project_badge(3, 1, link_url: 'http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}', image_url: 'https://shields.io/my/badge')
    end

    it 'gets the correct resource' do
      expect(a_put('/projects/3/badges/1')
        .with(body: { link_url: 'http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}', image_url: 'https://shields.io/my/badge' })).to have_been_made
    end

    it 'returns information about an edited project badge' do
      expect(@project_badge.link_url).to eq('http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}')
      expect(@project_badge.image_url).to eq('https://shields.io/my/badge')
    end
  end

  describe '.remove_project_badge' do
    before do
      stub_delete('/projects/3/badges/3', 'empty')
      @project_badge = Gitlab.remove_project_badge(3, 3)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/3/badges/3')).to have_been_made
    end
  end

  describe '.preview_project_badge' do
    before do
      stub_get('/projects/3/badges/render?image_url=https://shields.io/my/badge&link_url=http://example.com/ci_status.svg?project=%25%7Bproject_path%7D%26ref=%25%7Bdefault_branch%7D', 'preview_project_badge')
      @preview_project_badge = Gitlab.preview_project_badge(3, 'http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}', 'https://shields.io/my/badge')
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/badges/render?image_url=https://shields.io/my/badge&link_url=http://example.com/ci_status.svg?project=%25%7Bproject_path%7D%26ref=%25%7Bdefault_branch%7D')).to have_been_made
    end

    it 'returns information about the rendered values of a badge' do
      expect(@preview_project_badge.link_url).to eq('http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}')
      expect(@preview_project_badge.image_url).to eq('https://shields.io/my/badge')
    end
  end
end
# rubocop:enable Style/FormatStringToken
