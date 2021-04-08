# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
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

  describe '.license_templates' do
    before do
      stub_get('/templates/licenses', 'license_templates')
      @license_templates = Gitlab.license_templates
    end

    it 'gets the correct resource' do
      expect(a_get('/templates/licenses')).to have_been_made
    end

    it 'returns a paginated response of license templates' do
      expect(@license_templates).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.license_template' do
    before do
      stub_get('/templates/licenses/mit', 'license_template')
      @license_template = Gitlab.license_template('mit')
    end

    it 'gets the correct resource' do
      expect(a_get('/templates/licenses/mit')).to have_been_made
    end

    it 'returns the correct information about the license template' do
      expect(@license_template.key).to eq 'mit'
    end
  end
end
