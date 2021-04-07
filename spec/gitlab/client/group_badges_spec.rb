# frozen_string_literal: true

# rubocop:disable Style/FormatStringToken

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.group_badges' do
    before do
      stub_get('/groups/3/badges', 'group_badges')
      @group_badges = Gitlab.group_badges(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/badges')).to have_been_made
    end

    it "returns a paginated response of group's badges" do
      expect(@group_badges).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.group_badge' do
    before do
      stub_get('/groups/3/badges/1', 'group_badge')
      @group_badge = Gitlab.group_badge(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/badges/1')).to have_been_made
    end

    it 'returns information about a badge' do
      expect(@group_badge.id).to eq(1)
    end
  end

  describe '.add_group_badge' do
    before do
      stub_post('/groups/3/badges', 'group_badge')
      @group_badge = Gitlab.add_group_badge(3, link_url: 'http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}', image_url: 'https://shields.io/my/badge')
    end

    it 'gets the correct resource' do
      expect(a_post('/groups/3/badges')
        .with(body: { link_url: 'http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}', image_url: 'https://shields.io/my/badge' })).to have_been_made
    end

    it 'returns information about an added group badge' do
      expect(@group_badge.link_url).to eq('http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}')
      expect(@group_badge.image_url).to eq('https://shields.io/my/badge')
    end
  end

  describe '.edit_group_badge' do
    before do
      stub_put('/groups/3/badges/1', 'group_badge')
      @group_badge = Gitlab.edit_group_badge(3, 1, link_url: 'http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}', image_url: 'https://shields.io/my/badge')
    end

    it 'gets the correct resource' do
      expect(a_put('/groups/3/badges/1')
        .with(body: { link_url: 'http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}', image_url: 'https://shields.io/my/badge' })).to have_been_made
    end

    it 'returns information about an edited group badge' do
      expect(@group_badge.link_url).to eq('http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}')
      expect(@group_badge.image_url).to eq('https://shields.io/my/badge')
    end
  end

  describe '.remove_group_badge' do
    before do
      stub_delete('/groups/3/badges/3', 'empty')
      @group_badge = Gitlab.remove_group_badge(3, 3)
    end

    it 'gets the correct resource' do
      expect(a_delete('/groups/3/badges/3')).to have_been_made
    end
  end

  describe '.preview_group_badge' do
    before do
      stub_get('/groups/3/badges/render?image_url=https://shields.io/my/badge&link_url=http://example.com/ci_status.svg?project=%25%7Bproject_path%7D%26ref=%25%7Bdefault_branch%7D', 'preview_group_badge')
      @preview_group_badge = Gitlab.preview_group_badge(3, 'http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}', 'https://shields.io/my/badge')
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/badges/render?image_url=https://shields.io/my/badge&link_url=http://example.com/ci_status.svg?project=%25%7Bproject_path%7D%26ref=%25%7Bdefault_branch%7D')).to have_been_made
    end

    it 'returns information about the rendered values of a badge' do
      expect(@preview_group_badge.link_url).to eq('http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}')
      expect(@preview_group_badge.image_url).to eq('https://shields.io/my/badge')
    end
  end
end
# rubocop:enable Style/FormatStringToken
