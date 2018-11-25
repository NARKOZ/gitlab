# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.gitignore_templates' do
    before do
      stub_get('/templates/gitignores', 'gitignore_templates')
      @gitignore_templates = Gitlab.gitignore_templates
    end

    it 'gets the correct resource' do
      expect(a_get('/templates/gitignores')).to have_been_made
    end

    it 'returns a paginated response of gitignore templates' do
      expect(@gitignore_templates).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.gitignore_template' do
    before do
      stub_get('/templates/gitignores/Ruby', 'gitignore_template')
      @gitignore_template = Gitlab.gitignore_template('Ruby')
    end

    it 'gets the correct resource' do
      expect(a_get('/templates/gitignores/Ruby')).to have_been_made
    end

    it 'returns the correct information about the gitignore template' do
      expect(@gitignore_template.name).to eq 'Ruby'
    end
  end
end
