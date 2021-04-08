# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
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

  describe '.pipeline_bridges' do
    before do
      stub_get('/projects/1/pipelines/1/bridges', 'pipeline_bridges')
      @jobs = Gitlab.pipeline_bridges(1, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/pipelines/1/bridges')).to have_been_made
    end
  end

  describe '.pipeline_bridges - with scope' do
    before do
      stub_get('/projects/1/pipelines/1/bridges?scope[]=running&scope[]=created', 'pipeline_bridges')
      @jobs = Gitlab.pipeline_bridges(1, 1, scope: %w[running created])
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/pipelines/1/bridges?scope[]=running&scope[]=created')).to have_been_made
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
    context 'when successful request' do
      before do
        fixture = load_fixture('job_artifacts.zip')
        fixture.set_encoding(Encoding::ASCII_8BIT)
        stub_request(:get, "#{Gitlab.endpoint}/projects/3/jobs/artifacts/master/download")
          .with(query: { job: 'test' }, headers: { 'PRIVATE-TOKEN' => Gitlab.private_token })
          .to_return(body: fixture.read, headers: { 'Content-Disposition' => 'attachment; filename=job_artifacts.zip' })
        @job_artifacts = Gitlab.job_artifacts_download(3, 'master', 'test')
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/3/jobs/artifacts/master/download')
              .with(query: { job: 'test' })).to have_been_made
      end

      it 'returns a FileResponse' do
        expect(@job_artifacts).to be_a Gitlab::FileResponse
      end

      it 'returns a file with filename' do
        expect(@job_artifacts.filename).to eq 'job_artifacts.zip'
      end
    end

    context 'when bad request' do
      it 'throws an exception' do
        stub_get('/projects/3/jobs/artifacts/master/download', 'error_project_not_found', 404)
          .with(query: { job: 'test' })
        expect { Gitlab.job_artifacts_download(3, 'master', 'test') }.to raise_error(Gitlab::Error::NotFound, "Server responded with code 404, message: 404 Project Not Found. Request URI: #{Gitlab.endpoint}/projects/3/jobs/artifacts/master/download")
      end
    end
  end

  describe '.download_job_artifact_file' do
    context 'when successful request' do
      before do
        fixture = load_fixture('raw_file.txt')
        fixture.set_encoding(Encoding::ASCII_8BIT)
        stub_request(:get, "#{Gitlab.endpoint}/projects/3/jobs/5/artifacts/raw_file.txt")
          .with(headers: { 'PRIVATE-TOKEN' => Gitlab.private_token })
          .to_return(body: fixture.read, headers: { 'Content-Disposition' => 'attachment; filename=raw_file.txt' })
        @job_artifact_file = Gitlab.download_job_artifact_file(3, 5, 'raw_file.txt')
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/3/jobs/5/artifacts/raw_file.txt')).to have_been_made
      end

      it 'returns a FileResponse' do
        expect(@job_artifact_file).to be_a Gitlab::FileResponse
      end

      it 'returns a file with filename' do
        expect(@job_artifact_file.filename).to eq 'raw_file.txt'
      end
    end

    context 'when bad request' do
      it 'throws an exception' do
        stub_get('/projects/3/jobs/5/artifacts/raw_file.txt', 'error_project_not_found', 404)
        expect { Gitlab.download_job_artifact_file(3, 5, 'raw_file.txt') }.to raise_error(Gitlab::Error::NotFound, "Server responded with code 404, message: 404 Project Not Found. Request URI: #{Gitlab.endpoint}/projects/3/jobs/5/artifacts/raw_file.txt")
      end
    end
  end

  describe '.download_branch_artifact_file' do
    context 'when successful request' do
      before do
        fixture = load_fixture('raw_file.txt')
        fixture.set_encoding(Encoding::ASCII_8BIT)
        stub_request(:get, "#{Gitlab.endpoint}/projects/1/jobs/artifacts/master/raw/raw_file.txt")
          .with(query: { job: 'txt' }, headers: { 'PRIVATE-TOKEN' => Gitlab.private_token })
          .to_return(body: fixture.read, headers: { 'Content-Disposition' => 'attachment; filename=raw_file.txt' })
        @branch_artifact_file = Gitlab.download_branch_artifact_file(1, 'master', 'raw_file.txt', 'txt')
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/1/jobs/artifacts/master/raw/raw_file.txt')
            .with(query: { job: 'txt' })).to have_been_made
      end

      it 'returns a FileResponse' do
        expect(@branch_artifact_file).to be_a Gitlab::FileResponse
      end

      it 'returns a file with filename' do
        expect(@branch_artifact_file.filename).to eq 'raw_file.txt'
      end
    end

    context 'when bad request' do
      it 'throws an exception' do
        stub_get('/projects/1/jobs/artifacts/master/raw/raw_file.txt', 'error_project_not_found', 404)
          .with(query: { job: 'txt' })
        expect { Gitlab.download_branch_artifact_file(1, 'master', 'raw_file.txt', 'txt') }.to raise_error(Gitlab::Error::NotFound, "Server responded with code 404, message: 404 Project Not Found. Request URI: #{Gitlab.endpoint}/projects/1/jobs/artifacts/master/raw/raw_file.txt")
      end
    end
  end

  describe '.download_tag_artifact_file' do
    context 'when successful request' do
      before do
        fixture = load_fixture('raw_file.txt')
        fixture.set_encoding(Encoding::ASCII_8BIT)
        stub_request(:get, "#{Gitlab.endpoint}/projects/1/jobs/artifacts/release/raw/raw_file.txt")
          .with(query: { job: 'txt' }, headers: { 'PRIVATE-TOKEN' => Gitlab.private_token })
          .to_return(body: fixture.read, headers: { 'Content-Disposition' => 'attachment; filename=raw_file.txt' })
        @branch_artifact_file = Gitlab.download_tag_artifact_file(1, 'release', 'raw_file.txt', 'txt')
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/1/jobs/artifacts/release/raw/raw_file.txt')
            .with(query: { job: 'txt' })).to have_been_made
      end

      it 'returns a FileResponse' do
        expect(@branch_artifact_file).to be_a Gitlab::FileResponse
      end

      it 'returns a file with filename' do
        expect(@branch_artifact_file.filename).to eq 'raw_file.txt'
      end
    end

    context 'when bad request' do
      it 'throws an exception' do
        stub_get('/projects/1/jobs/artifacts/release/raw/raw_file.txt', 'error_project_not_found', 404)
          .with(query: { job: 'txt' })
        expect { Gitlab.download_tag_artifact_file(1, 'release', 'raw_file.txt', 'txt') }.to raise_error(Gitlab::Error::NotFound, "Server responded with code 404, message: 404 Project Not Found. Request URI: #{Gitlab.endpoint}/projects/1/jobs/artifacts/release/raw/raw_file.txt")
      end
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

  describe '.job_artifacts_delete' do
    before do
      stub_delete('/projects/1/jobs/1/artifacts', 'job')
      @projects = Gitlab.job_artifacts_delete(1, 1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/1/jobs/1/artifacts')).to have_been_made
    end
  end
end
