require 'spec_helper'

describe Gitlab::Client do
  describe '.jobs' do
    before do
      stub_get('/projects/1/jobs', 'jobs')
      @projects = Gitlab.jobs(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/jobs')).to have_been_made
    end
  end

  describe '.jobs - with scopes' do
    before do
      stub_get('/projects/1/jobs?scope[]=created&scope[]=running', 'jobs')
      @projects = Gitlab.jobs(1, scope: %w[created running])
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/jobs?scope[]=created&scope[]=running')).to have_been_made
    end
  end

  describe '.pipeline_jobs' do
    before do
      stub_get('/projects/1/pipelines/1/jobs', 'pipeline_jobs')
      @projects = Gitlab.pipeline_jobs(1, 1)
    end
    it 'gets the correct resource' do
      expect(a_get('/projects/1/pipelines/1/jobs')).to have_been_made
    end
  end

  describe '.pipeline_jobs - with scope' do
    before do
      stub_get('/projects/1/pipelines/1/jobs?scope[]=running&scope[]=created', 'pipeline_jobs')
      @projects = Gitlab.pipeline_jobs(1, 1, scope: %w[running created])
    end
    it 'gets the correct resource' do
      expect(a_get('/projects/1/pipelines/1/jobs?scope[]=running&scope[]=created')).to have_been_made
    end
  end

  describe '.job' do
    before do
      stub_get('/projects/1/jobs/1', 'job')
      @projects = Gitlab.job(1, 1)
    end
    it 'gets the correct resource' do
      expect(a_get('/projects/1/jobs/1')).to have_been_made
    end
  end

  describe '.job_artifacts' do
    before do
      stub_get('/projects/1/jobs/1/artifacts', 'job')
      @projects = Gitlab.job_artifacts(1, 1)
    end
    it 'gets the correct resource' do
      expect(a_get('/projects/1/jobs/1/artifacts')).to have_been_made
    end
  end

  describe '.job_artifacts_download' do
    before do
      stub_get('/projects/1/jobs/artifacts/master/download?job=Release%20Build', 'job')
      @projects = Gitlab.job_artifacts_download(1, 'master', 'Release Build')
    end
    it 'gets the correct resource' do
      expect(a_get('/projects/1/jobs/artifacts/master/download?job=Release%20Build')).to have_been_made
    end
  end

  describe '.job_trace' do
    before do
      stub_get('/projects/1/jobs/1/trace', 'job_trace')
      @projects = Gitlab.job_trace(1, 1)
    end
    it 'gets the correct resource' do
      expect(a_get('/projects/1/jobs/1/trace')).to have_been_made
    end
  end

  describe '.job_cancel' do
    before do
      stub_post('/projects/1/jobs/1/cancel', 'job')
      @projects = Gitlab.job_cancel(1, 1)
    end
    it 'gets the correct resource' do
      expect(a_post('/projects/1/jobs/1/cancel')).to have_been_made
    end
  end

  describe '.job_retry' do
    before do
      stub_post('/projects/1/jobs/1/retry', 'job')
      @projects = Gitlab.job_retry(1, 1)
    end
    it 'gets the correct resource' do
      expect(a_post('/projects/1/jobs/1/retry')).to have_been_made
    end
  end

  describe '.job_erase' do
    before do
      stub_post('/projects/1/jobs/1/erase', 'job')
      @projects = Gitlab.job_erase(1, 1)
    end
    it 'gets the correct resource' do
      expect(a_post('/projects/1/jobs/1/erase')).to have_been_made
    end
  end

  describe '.job_play' do
    before do
      stub_post('/projects/1/jobs/1/play', 'job')
      @projects = Gitlab.job_play(1, 1)
    end
    it 'gets the correct resource' do
      expect(a_post('/projects/1/jobs/1/play')).to have_been_made
    end
  end

  describe '.job_artifacts_keep' do
    before do
      stub_post('/projects/1/jobs/1/artifacts/keep', 'job')
      @projects = Gitlab.job_artifacts_keep(1, 1)
    end
    it 'gets the correct resource' do
      expect(a_post('/projects/1/jobs/1/artifacts/keep')).to have_been_made
    end
  end
end
