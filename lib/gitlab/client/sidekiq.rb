# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to sidekiq metrics.
  # @see https://docs.gitlab.com/ce/api/sidekiq_metrics.html
  module Sidekiq
    # Get the current Queue Metrics
    #
    # @example
    #   Gitlab.sidekiq_queue_metrics
    def sidekiq_queue_metrics
      get('/sidekiq/queue_metrics')
    end

    # Get the current Process Metrics
    #
    # @example
    #   Gitlab.sidekiq_process_metrics
    def sidekiq_process_metrics
      get('/sidekiq/process_metrics')
    end

    # Get the current Job Statistics
    #
    # @example
    #   Gitlab.sidekiq_job_stats
    def sidekiq_job_stats
      get('/sidekiq/job_stats')
    end

    # Get a compound response of all the previously mentioned metrics
    #
    # @example
    #   Gitlab.sidekiq_compound_metrics
    def sidekiq_compound_metrics
      get('/sidekiq/compound_metrics')
    end
  end
end
