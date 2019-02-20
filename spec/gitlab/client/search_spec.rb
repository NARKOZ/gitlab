# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.search_globally' do
    context 'when scope projects' do
      before do
        stub_get('/search', 'search_projects_results').with(query: { scope: 'projects', search: 'flight' })
        @search = Gitlab.search_globally('projects', 'flight')
      end

      it 'gets the correct resource' do
        expect(a_get('/search')
          .with(query: { scope: 'projects', search: 'flight' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
      end
    end

    context 'when scope issues' do
      before do
        stub_get('/search', 'search_issues_results').with(query: { scope: 'issues', search: 'file' })
        @search = Gitlab.search_globally('issues', 'file')
      end

      it 'gets the correct resource' do
        expect(a_get('/search')
          .with(query: { scope: 'issues', search: 'file' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
      end
    end

    context 'when scope merge_requests' do
      before do
        stub_get('/search', 'search_merge_requests_results').with(query: { scope: 'merge_requests', search: 'file' })
        @search = Gitlab.search_globally('merge_requests', 'file')
      end

      it 'gets the correct resource' do
        expect(a_get('/search')
          .with(query: { scope: 'merge_requests', search: 'file' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
      end
    end

    context 'when scope milestones' do
      before do
        stub_get('/search', 'search_milestones_results').with(query: { scope: 'milestones', search: 'release' })
        @search = Gitlab.search_globally('milestones', 'release')
      end

      it 'gets the correct resource' do
        expect(a_get('/search')
          .with(query: { scope: 'milestones', search: 'release' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
      end
    end

    context 'when scope snippet_titles' do
      before do
        stub_get('/search', 'search_snippet_titles_results').with(query: { scope: 'snippet_titles', search: 'sample' })
        @search = Gitlab.search_globally('snippet_titles', 'sample')
      end

      it 'gets the correct resource' do
        expect(a_get('/search')
          .with(query: { scope: 'snippet_titles', search: 'sample' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
      end
    end

    context 'when scope snippet_blobs' do
      before do
        stub_get('/search', 'search_snippet_blobs_results').with(query: { scope: 'snippet_blobs', search: 'test' })
        @search = Gitlab.search_globally('snippet_blobs', 'test')
      end

      it 'gets the correct resource' do
        expect(a_get('/search')
          .with(query: { scope: 'snippet_blobs', search: 'test' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
      end
    end
  end

  describe '.search_in_group' do
    context 'when scope projects' do
      before do
        stub_get('/groups/3/search', 'search_projects_results').with(query: { scope: 'projects', search: 'flight' })
        @search = Gitlab.search_in_group(3, 'projects', 'flight')
      end

      it 'gets the correct resource' do
        expect(a_get('/groups/3/search')
          .with(query: { scope: 'projects', search: 'flight' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
      end
    end

    context 'when scope issues' do
      before do
        stub_get('/groups/3/search', 'search_issues_results').with(query: { scope: 'issues', search: 'file' })
        @search = Gitlab.search_in_group(3, 'issues', 'file')
      end

      it 'gets the correct resource' do
        expect(a_get('/groups/3/search')
          .with(query: { scope: 'issues', search: 'file' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
      end
    end

    context 'when scope merge_requests' do
      before do
        stub_get('/groups/3/search', 'search_merge_requests_results').with(query: { scope: 'merge_requests', search: 'file' })
        @search = Gitlab.search_in_group(3, 'merge_requests', 'file')
      end

      it 'gets the correct resource' do
        expect(a_get('/groups/3/search')
          .with(query: { scope: 'merge_requests', search: 'file' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
      end
    end

    context 'when scope milestones' do
      before do
        stub_get('/groups/3/search', 'search_milestones_results').with(query: { scope: 'milestones', search: 'release' })
        @search = Gitlab.search_in_group(3, 'milestones', 'release')
      end

      it 'gets the correct resource' do
        expect(a_get('/groups/3/search')
          .with(query: { scope: 'milestones', search: 'release' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
      end
    end
  end

  describe '.search_in_project' do
    context 'when scope issues' do
      before do
        stub_get('/projects/12/search', 'search_issues_results').with(query: { scope: 'issues', search: 'file' })
        @search = Gitlab.search_in_project(12, 'issues', 'file')
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/12/search')
          .with(query: { scope: 'issues', search: 'file' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
        expect(@search[0].project_id).to eq(12)
      end
    end

    context 'when scope merge_requests' do
      before do
        stub_get('/projects/6/search', 'search_merge_requests_results').with(query: { scope: 'merge_requests', search: 'file' })
        @search = Gitlab.search_in_project(6, 'merge_requests', 'file')
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/6/search')
          .with(query: { scope: 'merge_requests', search: 'file' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
        expect(@search[0].project_id).to eq(6)
      end
    end

    context 'when scope milestones' do
      before do
        stub_get('/projects/12/search', 'search_milestones_results').with(query: { scope: 'milestones', search: 'release' })
        @search = Gitlab.search_in_project(12, 'milestones', 'release')
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/12/search')
          .with(query: { scope: 'milestones', search: 'release' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
        expect(@search[0].project_id).to eq(12)
      end
    end

    context 'when scope notes' do
      before do
        stub_get('/projects/6/search', 'search_notes_results').with(query: { scope: 'notes', search: 'maxime' })
        @search = Gitlab.search_in_project(6, 'notes', 'maxime')
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/6/search')
          .with(query: { scope: 'notes', search: 'maxime' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
      end
    end

    context 'when scope wiki_blobs' do
      before do
        stub_get('/projects/6/search', 'search_wiki_blobs_results').with(query: { scope: 'wiki_blobs', search: 'bye' })
        @search = Gitlab.search_in_project(6, 'wiki_blobs', 'bye')
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/6/search')
          .with(query: { scope: 'wiki_blobs', search: 'bye' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
        expect(@search[0].project_id).to eq(6)
      end
    end

    context 'when scope commits' do
      before do
        stub_get('/projects/6/search', 'search_commits_results').with(query: { scope: 'commits', search: 'bye' })
        @search = Gitlab.search_in_project(6, 'commits', 'bye')
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/6/search')
          .with(query: { scope: 'commits', search: 'bye' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
        expect(@search[0].project_id).to eq(6)
      end
    end

    context 'when scope blobs' do
      before do
        stub_get('/projects/6/search', 'search_blobs_results').with(query: { scope: 'blobs', search: 'installation' })
        @search = Gitlab.search_in_project(6, 'blobs', 'installation')
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/6/search')
          .with(query: { scope: 'blobs', search: 'installation' })).to have_been_made
      end

      it 'returns a paginated response of search results' do
        expect(@search).to be_a Gitlab::PaginatedResponse
        expect(@search[0].project_id).to eq(6)
      end
    end
  end
end
