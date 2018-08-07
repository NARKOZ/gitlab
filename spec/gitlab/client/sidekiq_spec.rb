# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.sidekiq_queue_metrics' do
    before do
      stub_get('/sidekiq/queue_metrics', 'sidekiq_queue_metrics')
      @sidekiq_queue_metrics = Gitlab.sidekiq_queue_metrics
    end

    it 'gets the correct resource' do
      expect(a_get('/sidekiq/queue_metrics')).to have_been_made
    end

    it 'returns a information about a sidekiq default queue' do
      expect(@sidekiq_queue_metrics.queues.default.backlog).to eq 0
      expect(@sidekiq_queue_metrics.queues.default.latency).to eq 0
    end
  end

  describe '.sidekiq_process_metrics' do
    before do
      stub_get('/sidekiq/process_metrics', 'sidekiq_process_metrics')
      @sidekiq_process_metrics = Gitlab.sidekiq_process_metrics
    end

    it 'gets the correct resource' do
      expect(a_get('/sidekiq/process_metrics')).to have_been_made
    end

    it 'returns a information about a sidekiq process metrics' do
      expect(@sidekiq_process_metrics.processes.first['busy']).to eq 0
    end
  end

  describe '.sidekiq_job_stats' do
    before do
      stub_get('/sidekiq/job_stats', 'sidekiq_job_stats')
      @sidekiq_job_stats = Gitlab.sidekiq_job_stats
    end

    it 'gets the correct resource' do
      expect(a_get('/sidekiq/job_stats')).to have_been_made
    end

    it 'returns a information about a sidekiq process metrics' do
      expect(@sidekiq_job_stats.jobs.processed).to eq 2
    end
  end

  describe '.sidekiq_compound_metrics' do
    before do
      stub_get('/sidekiq/compound_metrics', 'sidekiq_compound_metrics')
      @sidekiq_compound_metrics = Gitlab.sidekiq_compound_metrics
    end

    it 'gets the correct resource' do
      expect(a_get('/sidekiq/compound_metrics')).to have_been_made
    end

    it 'returns a information about a sidekiq process metrics' do
      expect(@sidekiq_compound_metrics.jobs.processed).to eq 2
    end
  end
end
