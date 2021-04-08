# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.project_releases' do
    before do
      stub_get('/projects/3/releases', 'project_releases')
      @project_releases = Gitlab.project_releases(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/releases')).to have_been_made
    end

    it "returns a paginated response of project's releases" do
      expect(@project_releases).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.project_release' do
    before do
      stub_get('/projects/3/releases/v0.1', 'project_release')
      @project_release = Gitlab.project_release(3, 'v0.1')
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/releases/v0.1')).to have_been_made
    end

    it 'returns information about a release' do
      expect(@project_release.tag_name).to eq('v0.1')
    end
  end

  describe '.create_project_release' do
    context 'without asset links' do
      before do
        stub_post('/projects/5/releases', 'project_release')
        @project_release = Gitlab.create_project_release(5, name: 'Awesome app v0.1 alpha', tag_name: 'v0.1', description: "## CHANGELOG\r\n\r\n- Remove limit of 100 when searching repository code. !8671\r\n- Show error message when attempting to reopen an MR and there is an open MR for the same branch. !16447 (Akos Gyimesi)\r\n- Fix a bug where internal email pattern wasn't respected. !22516")
      end

      it 'gets the correct resource' do
        expect(a_post('/projects/5/releases')
          .with(body: { name: 'Awesome app v0.1 alpha', tag_name: 'v0.1', description: "## CHANGELOG\r\n\r\n- Remove limit of 100 when searching repository code. !8671\r\n- Show error message when attempting to reopen an MR and there is an open MR for the same branch. !16447 (Akos Gyimesi)\r\n- Fix a bug where internal email pattern wasn't respected. !22516" })).to have_been_made
      end

      it 'returns information about the created release' do
        expect(@project_release.name).to eq('Awesome app v0.1 alpha')
        expect(@project_release.tag_name).to eq('v0.1')
        expect(@project_release.description).to eq("## CHANGELOG\r\n\r\n- Remove limit of 100 when searching repository code. !8671\r\n- Show error message when attempting to reopen an MR and there is an open MR for the same branch. !16447 (Akos Gyimesi)\r\n- Fix a bug where internal email pattern wasn't respected. !22516")
      end
    end

    context 'with asset links' do
      before do
        stub_post('/projects/5/releases', 'project_release_with_assets')
        @project_release = Gitlab.create_project_release(5, name: 'Awesome app v0.1 alpha', tag_name: 'v0.1', description: "## CHANGELOG\r\n\r\n- Remove limit of 100 when searching repository code. !8671\r\n- Show error message when attempting to reopen an MR and there is an open MR for the same branch. !16447 (Akos Gyimesi)\r\n- Fix a bug where internal email pattern wasn't respected. !22516", assets: { links: [{ name: 'awesome-v0.2.msi', url: 'http://192.168.10.15:3000/msi' }, { name: 'awesome-v0.2.dmg', url: 'http://192.168.10.15:3000' }] })
      end

      it 'gets the correct resource' do
        expect(a_post('/projects/5/releases')
          .with(body: { name: 'Awesome app v0.1 alpha', tag_name: 'v0.1', description: "## CHANGELOG\r\n\r\n- Remove limit of 100 when searching repository code. !8671\r\n- Show error message when attempting to reopen an MR and there is an open MR for the same branch. !16447 (Akos Gyimesi)\r\n- Fix a bug where internal email pattern wasn't respected. !22516", assets: { links: [{ name: 'awesome-v0.2.msi', url: 'http://192.168.10.15:3000/msi' }, { name: 'awesome-v0.2.dmg', url: 'http://192.168.10.15:3000' }] } })).to have_been_made
      end

      it 'returns information about the created release' do
        expect(@project_release.name).to eq('Awesome app v0.1 alpha')
        expect(@project_release.tag_name).to eq('v0.1')
        expect(@project_release.description).to eq("## CHANGELOG\r\n\r\n- Remove limit of 100 when searching repository code. !8671\r\n- Show error message when attempting to reopen an MR and there is an open MR for the same branch. !16447 (Akos Gyimesi)\r\n- Fix a bug where internal email pattern wasn't respected. !22516")
        expect(@project_release.assets.links[0]['name']).to eq('awesome-v0.2.msi')
        expect(@project_release.assets.links[0]['url']).to eq('http://192.168.10.15:3000/msi')
        expect(@project_release.assets.links[1]['name']).to eq('awesome-v0.2.dmg')
        expect(@project_release.assets.links[1]['url']).to eq('http://192.168.10.15:3000')
      end
    end
  end

  describe '.update_project_release' do
    before do
      stub_put('/projects/5/releases/v0.1', 'project_release')
      @project_release = Gitlab.update_project_release(5, 'v0.1', name: 'Awesome app v0.1 alpha')
    end

    it 'gets the correct resource' do
      expect(a_put('/projects/5/releases/v0.1')
        .with(body: { name: 'Awesome app v0.1 alpha' })).to have_been_made
    end

    it 'returns information about an updated project release' do
      expect(@project_release.name).to eq('Awesome app v0.1 alpha')
    end
  end

  describe '.delete_project_release' do
    before do
      stub_delete('/projects/3/releases/v0.1', 'project_release')
      @project_release = Gitlab.delete_project_release(3, 'v0.1')
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/3/releases/v0.1')).to have_been_made
    end

    it 'returns information about the deleted project release' do
      expect(@project_release.tag_name).to eq('v0.1')
    end
  end
end
