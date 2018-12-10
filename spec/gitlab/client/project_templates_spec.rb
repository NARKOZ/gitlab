# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.project_templates' do
    before do
      stub_get('/projects/3/templates/licenses', 'project_templates')
      @project_templates = Gitlab.project_templates(3, 'licenses')
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/templates/licenses')).to have_been_made
    end

    it "returns a paginated response of project's templates" do
      expect(@project_templates).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.project_template' do
    context 'when dockerfiles' do
      before do
        stub_get('/projects/3/templates/dockerfiles/dock', 'dockerfile_project_template')
        @project_template = Gitlab.project_template(3, 'dockerfiles', 'dock')
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/3/templates/dockerfiles/dock')).to have_been_made
      end
    end

    context 'when licenses' do
      before do
        stub_get('/projects/3/templates/licenses/mit', 'license_project_template')
        @project_template = Gitlab.project_template(3, 'licenses', 'mit')
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/3/templates/licenses/mit')).to have_been_made
      end
    end
  end
end
