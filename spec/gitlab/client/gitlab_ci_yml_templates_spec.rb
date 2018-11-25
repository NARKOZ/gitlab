# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.gitlab_ci_yml_templates' do
    before do
      stub_get('/templates/gitlab_ci_ymls', 'gitlab_ci_yml_templates')
      @gitlab_ci_yml_templates = Gitlab.gitlab_ci_yml_templates
    end

    it 'gets the correct resource' do
      expect(a_get('/templates/gitlab_ci_ymls')).to have_been_made
    end

    it 'returns a paginated response of gitlab_ci_yml templates' do
      expect(@gitlab_ci_yml_templates).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.gitlab_ci_yml_template' do
    before do
      stub_get('/templates/gitlab_ci_ymls/Ruby', 'gitlab_ci_yml_template')
      @gitlab_ci_yml_template = Gitlab.gitlab_ci_yml_template('Ruby')
    end

    it 'gets the correct resource' do
      expect(a_get('/templates/gitlab_ci_ymls/Ruby')).to have_been_made
    end

    it 'returns the correct information about the gitlab_ci_yml template' do
      expect(@gitlab_ci_yml_template.name).to eq 'Ruby'
    end
  end
end
