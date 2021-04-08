# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  it { is_expected.to respond_to :issue_links }
  it { is_expected.to respond_to :create_issue_link }
  it { is_expected.to respond_to :delete_issue_link }

  describe '.issue_links' do
    before do
      stub_get('/projects/4/issues/14/links', 'project_issue_links')
      @issue_link = Gitlab.issue_links(4, 14)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/4/issues/14/links')).to have_been_made
    end

    it 'returns a paginated response of projects' do
      expect(@issue_link).to be_a Gitlab::PaginatedResponse
      expect(@issue_link.first.title).to eq('Issues with auth')
      expect(@issue_link.first.author.name).to eq('Alexandra Bashirian')
    end
  end

  describe '.create_issue_link' do
    before do
      stub_post('/projects/3/issues/14/links', 'create_issue_link')
      @issue_link = Gitlab.create_issue_link(3, 14, 4, 11)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/issues/14/links')
        .with(body: { target_project_id: 4, target_issue_iid: 11 })).to have_been_made
    end

    it 'returns information about a created issue' do
      expect(@issue_link.source_issue.iid).to eq(11)
      expect(@issue_link.target_issue.iid).to eq(14)
    end
  end

  describe '.delete_issue_link' do
    before do
      stub_delete('/projects/3/issues/14/links/1', 'delete_issue_link')
      @issue_link = Gitlab.delete_issue_link(3, 14, 1)
    end

    it 'deletes the correct resource' do
      expect(a_delete('/projects/3/issues/14/links/1')).to have_been_made
    end

    it 'returns information about the deleted issue link' do
      expect(@issue_link.source_issue.iid).to eq(11)
      expect(@issue_link.target_issue.iid).to eq(14)
    end
  end
end
