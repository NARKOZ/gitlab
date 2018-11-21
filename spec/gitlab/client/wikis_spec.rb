# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.wikis' do
    before do
      stub_get('/projects/1/wikis', 'wikis')
      @wikis = Gitlab.wikis(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/wikis')).to have_been_made
    end

    it "returns a response of a project's wikis" do
      expect(@wikis).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.wiki' do
    before do
      stub_get('/projects/1/wikis/home', 'wiki')
      @wiki = Gitlab.wiki(1, 'home')
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/wikis/home')).to have_been_made
    end

    it 'returns correct information about the wiki' do
      expect(@wiki.slug).to eq 'home'
    end
  end

  describe '.create_wiki' do
    before do
      stub_post('/projects/1/wikis', 'wiki')
      @wiki = Gitlab.create_wiki(1, 'home', 'home page')
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/1/wikis')
        .with(body: { content: 'home page', title: 'home' })).to have_been_made
    end

    it 'returns correct information about the created wiki' do
      expect(@wiki.content).to eq 'home page'
      expect(@wiki.title).to eq 'home'
    end
  end

  describe '.update_wiki' do
    before do
      stub_put('/projects/1/wikis/home', 'wiki')
      @wiki = Gitlab.update_wiki(1, 'home', format: 'markdown')
    end

    it 'gets the correct resource' do
      expect(a_put('/projects/1/wikis/home')
        .with(body: { format: 'markdown' })).to have_been_made
    end

    it 'returns correct information about the updated wiki' do
      expect(@wiki.format).to eq 'markdown'
    end
  end

  describe '.delete_wiki' do
    before do
      stub_delete('/projects/1/wikis/home', 'empty')
      @wiki = Gitlab.delete_wiki(1, 'home')
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/1/wikis/home')).to have_been_made
    end
  end
end
