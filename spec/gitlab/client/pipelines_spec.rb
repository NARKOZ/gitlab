# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.pipelines' do
    before do
      stub_get('/projects/3/pipelines', 'pipelines')
      @pipelines = Gitlab.pipelines(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/pipelines')).to have_been_made
    end

    it "returns a paginated response of project's pipelines" do
      expect(@pipelines).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.pipeline' do
    before do
      stub_get('/projects/3/pipelines/46', 'pipeline')
      @pipeline = Gitlab.pipeline(3, 46)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/pipelines/46')).to have_been_made
    end

    it 'returns a single pipeline' do
      expect(@pipeline).to be_a Gitlab::ObjectifiedHash
    end

    it 'returns information about a pipeline' do
      expect(@pipeline.id).to eq(46)
      expect(@pipeline.user.name).to eq('Administrator')
    end
  end

  describe '.pipeline_test_report' do
    before do
      stub_get('/projects/3/pipelines/46/test_report', 'pipeline_test_report')
      @report = Gitlab.pipeline_test_report(3, 46)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/pipelines/46/test_report')).to have_been_made
    end

    it 'returns a single pipeline' do
      expect(@report).to be_a Gitlab::ObjectifiedHash
    end

    it 'returns information about a pipeline' do
      expect(@report.total_time).to eq(5)
      expect(@report.test_suites[0].name).to eq('Secure')
    end
  end

  describe '.pipeline_variables' do
    before do
      stub_get('/projects/3/pipelines/46/variables', 'pipeline_variables')
      @variables = Gitlab.pipeline_variables(3, 46)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/pipelines/46/variables')).to have_been_made
    end

    it 'returns a paginated response of pipeline variables' do
      expect(@variables).to be_a Gitlab::PaginatedResponse
    end

    it "returns pipeline's variables" do
      expect(@variables[0]['key']).to eq('RUN_NIGHTLY_BUILD')
    end
  end

  describe '.create_pipeline' do
    let(:pipeline_path) { '/projects/3/pipeline?ref=master' }

    before do
      stub_post(pipeline_path, 'pipeline_create')
      @pipeline_create = Gitlab.create_pipeline(3, 'master')
    end

    it 'gets the correct resource' do
      expect(a_post(pipeline_path)).to have_been_made
    end

    it 'returns a single pipeline' do
      expect(@pipeline_create).to be_a Gitlab::ObjectifiedHash
    end

    it 'returns information about a pipeline' do
      expect(@pipeline_create.user.name).to eq('Administrator')
    end

    context 'when variables are passed' do
      before do
        stub_post(pipeline_path, 'pipeline_create')
        variables = { 'VAR1' => 'value', VAR2: :value }
        @pipeline_create = Gitlab.create_pipeline(3, 'master', variables)
      end

      it 'calls with the correct body' do
        expected_body = 'variables[][key]=VAR1&variables[][value]=value&variables[][key]=VAR2&variables[][value]=value'
        expect(a_post(pipeline_path).with(body: expected_body.gsub('[', '%5B').gsub(']', '%5D'))).to have_been_made
      end
    end
  end

  describe '.cancel_pipeline' do
    before do
      stub_post('/projects/3/pipelines/46/cancel', 'pipeline_cancel')
      @pipeline_cancel = Gitlab.cancel_pipeline(3, 46)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/pipelines/46/cancel')).to have_been_made
    end

    it 'returns a single pipeline' do
      expect(@pipeline_cancel).to be_a Gitlab::ObjectifiedHash
    end

    it 'returns information about a pipeline' do
      expect(@pipeline_cancel.user.name).to eq('Administrator')
    end
  end

  describe '.retry_pipeline' do
    before do
      stub_post('/projects/3/pipelines/46/retry', 'pipeline_retry')
      @pipeline_retry = Gitlab.retry_pipeline(3, 46)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/pipelines/46/retry')).to have_been_made
    end

    it 'returns a single pipeline' do
      expect(@pipeline_retry).to be_a Gitlab::ObjectifiedHash
    end

    it 'returns information about a pipeline' do
      expect(@pipeline_retry.user.name).to eq('Administrator')
    end
  end

  describe '.delete_pipeline' do
    before do
      stub_delete('/projects/3/pipelines/46', 'empty')
      Gitlab.delete_pipeline(3, 46)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/3/pipelines/46')).to have_been_made
    end
  end

  describe '.update_pipeline_metadata' do
    before do
      stub_put('/projects/3/pipelines/46/metadata', 'pipeline')
      Gitlab.update_pipeline_metadata(3, 46, name: 'new pipeline name')
    end

    it 'gets the correct resource' do
      expect(
        a_put('/projects/3/pipelines/46/metadata').with(body: { name: 'new pipeline name' })
      ).to have_been_made
    end
  end
end
