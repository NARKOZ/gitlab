# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.dockerfile_templates' do
    before do
      stub_get('/templates/dockerfiles', 'dockerfile_templates')
      @dockerfile_templates = Gitlab.dockerfile_templates
    end

    it 'gets the correct resource' do
      expect(a_get('/templates/dockerfiles')).to have_been_made
    end

    it 'returns a paginated response of dockerfile templates' do
      expect(@dockerfile_templates).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.dockerfile_template' do
    before do
      stub_get('/templates/dockerfiles/Binary', 'dockerfile_project_template')
      @dockerfile_template = Gitlab.dockerfile_template('Binary')
    end

    it 'gets the correct resource' do
      expect(a_get('/templates/dockerfiles/Binary')).to have_been_made
    end

    it 'returns the correct information about the dockerfile template' do
      expect(@dockerfile_template.name).to eq 'Binary'
    end
  end
end
