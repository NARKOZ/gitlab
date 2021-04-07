# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.project_release_links' do
    before do
      stub_get('/projects/3/releases/v0.1/assets/links', 'project_release_links')
      @project_release_links = Gitlab.project_release_links(3, 'v0.1')
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/releases/v0.1/assets/links')).to have_been_made
    end

    it "returns a paginated response of project's release links" do
      expect(@project_release_links).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.project_release_link' do
    before do
      stub_get('/projects/3/releases/v0.1/assets/links/1', 'project_release_link')
      @project_release_link = Gitlab.project_release_link(3, 'v0.1', 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/releases/v0.1/assets/links/1')).to have_been_made
    end

    it "returns information about a project's release link" do
      expect(@project_release_link.id).to eq(1)
    end
  end

  describe '.create_project_release_link' do
    before do
      stub_post('/projects/5/releases/v0.1/assets/links', 'project_release_link')
      @project_release_link = Gitlab.create_project_release_link(5, 'v0.1', name: 'awesome-v0.2.dmg', url: 'http://192.168.10.15:3000')
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/5/releases/v0.1/assets/links')
        .with(body: { name: 'awesome-v0.2.dmg', url: 'http://192.168.10.15:3000' })).to have_been_made
    end

    it 'returns information about the created release link' do
      expect(@project_release_link.name).to eq('awesome-v0.2.dmg')
      expect(@project_release_link.url).to eq('http://192.168.10.15:3000')
    end
  end

  describe '.update_project_release_link' do
    before do
      stub_put('/projects/5/releases/v0.1/assets/links/1', 'project_release_link')
      @project_release_link = Gitlab.update_project_release_link(5, 'v0.1', 1, url: 'http://192.168.10.15:3000')
    end

    it 'gets the correct resource' do
      expect(a_put('/projects/5/releases/v0.1/assets/links/1')
        .with(body: { url: 'http://192.168.10.15:3000' })).to have_been_made
    end

    it 'returns information about an updated project release link' do
      expect(@project_release_link.url).to eq('http://192.168.10.15:3000')
    end
  end

  describe '.delete_project_release_link' do
    before do
      stub_delete('/projects/3/releases/v0.1/assets/links/1', 'project_release_link')
      @project_release_link = Gitlab.delete_project_release_link(3, 'v0.1', 1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/3/releases/v0.1/assets/links/1')).to have_been_made
    end

    it 'returns information about the deleted project release link' do
      expect(@project_release_link.id).to eq(1)
    end
  end
end
