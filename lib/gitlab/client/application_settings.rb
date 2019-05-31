# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to application settings.
  # @see https://docs.gitlab.com/ee/api/settings.html
  module ApplicationSettings
    # Retrives the application settings of Gitlab.
    #
    # @example
    #   Gitlab.application_settings
    #
    # @return [Array<Gitlab::ObjectifiedHash>]
    def application_settings
      get('/application/settings')
    end

    # Edit the applications settings of Gitlab.
    #
    # @example
    #   Gitlab.edit_application_settings({ signup_enabled: false })
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :admin_notification_email
    # @option options [String] :after_sign_out_path
    # @option options [String] :after_sign_up_text
    # @option options [String] :akismet_api_key
    # @option options [Boolean] :akismet_enabled
    # @option options [Boolean] :allow_group_owners_to_manage_ldap
    # @option options [Boolean] :allow_local_requests_from_hooks_and_services
    # @option options [Boolean] :authorized_keys_enabled
    # @option options [String] :auto_devops_domain
    # @option options [Boolean] :auto_devops_enabled
    # @option options [Boolean] :check_namespace_plan
    # @option options [String] :clientside_sentry_dsn
    # @option options [Boolean] :clientside_sentry_enabled
    # @option options [Integer] :container_registry_token_expire_delay
    # @option options [String] :default_artifacts_expire_in
    # @option options [Integer] :default_branch_protection
    # @option options [String] :default_group_visibility
    # @option options [String] :default_project_visibility
    # @option options [Integer] :default_projects_limit
    # @option options [String] :default_snippet_visibility
    # @option options [Array<String>] :disabled_oauth_sign_in_sources
    # @option options [Array<String>] :domain_blacklist
    # @option options [Boolean] :domain_blacklist_enabled
    # @option options [Array<String>] :domain_whitelist
    # @option options [Integer] :dsa_key_restriction
    # @option options [Integer] :ecdsa_key_restriction
    # @option options [Integer] :ed25519_key_restriction
    # @option options [Boolean] :elasticsearch_aws
    # @option options [String] :elasticsearch_aws_access_key
    # @option options [String] :elasticsearch_aws_region
    # @option options [String] :elasticsearch_aws_secret_access_key
    # @option options [Boolean] :elasticsearch_experimental_indexer
    # @option options [Boolean] :elasticsearch_indexing
    # @option options [Boolean] :elasticsearch_search
    # @option options [String] :elasticsearch_url
    # @option options [Boolean] :elasticsearch_limit_indexing
    # @option options [Array<Integer>] :elasticsearch_project_ids
    # @option options [Array<Integer>] :elasticsearch_namespace_ids
    # @option options [String] :email_additional_text
    # @option options [Boolean] :email_author_in_body
    # @option options [String] :enabled_git_access_protocol
    # @option options [Boolean] :enforce_terms
    # @option options [String] :external_auth_client_cert
    # @option options [String] :external_auth_client_key
    # @option options [String] :external_auth_client_key_pass
    # @option options [Boolean] :external_authorization_service_enabled
    # @option options [String] :external_authorization_service_default_label
    # @option options [Float] :external_authorization_service_timeout float
    # @option options [String] :external_authorization_service_url
    # @option options [Integer] :file_template_project_id
    # @option options [Integer] :first_day_of_week
    # @option options [Integer] :geo_status_timeout
    # @option options [Integer] :gitaly_timeout_default
    # @option options [Integer] :gitaly_timeout_fast
    # @option options [Integer] :gitaly_timeout_medium
    # @option options [Boolean] :gravatar_enabled
    # @option options [Boolean] :hashed_storage_enabled
    # @option options [Boolean] :help_page_hide_commercial_content
    # @option options [String] :help_page_support_url
    # @option options [String] :help_page_text
    # @option options [String] :help_text
    # @option options [Boolean] :hide_third_party_offers
    # @option options [String] :home_page_url
    # @option options [Boolean] :housekeeping_bitmaps_enabled
    # @option options [Boolean] :housekeeping_enabled
    # @option options [Integer] :housekeeping_full_repack_period
    # @option options [Integer] :housekeeping_gc_period
    # @option options [Integer] :housekeeping_incremental_repack_period
    # @option options [Boolean] :html_emails_enabled
    # @option options [Boolean] :instance_statistics_visibility_private
    # @option options [Array<String>] :import_sources
    # @option options [Integer] :max_artifacts_size
    # @option options [Integer] :max_attachment_size
    # @option options [Integer] :max_pages_size
    # @option options [Boolean] :metrics_enabled
    # @option options [String] :metrics_host
    # @option options [Integer] :metrics_method_call_threshold
    # @option options [Integer] :metrics_packet_size
    # @option options [Integer] :metrics_pool_size
    # @option options [Integer] :metrics_port
    # @option options [Integer] :metrics_sample_interval
    # @option options [Integer] :metrics_timeout
    # @option options [Boolean] :mirror_available
    # @option options [Integer] :mirror_capacity_threshold
    # @option options [Integer] :mirror_max_capacity
    # @option options [Integer] :mirror_max_delay
    # @option options [Boolean] :pages_domain_verification_enabled
    # @option options [Boolean] :password_authentication_enabled_for_git
    # @option options [Boolean] :password_authentication_enabled_for_web
    # @option options [String] :performance_bar_allowed_group_id
    # @option options [String] :performance_bar_allowed_group_path
    # @option options [Boolean] :performance_bar_enabled
    # @option options [Boolean] :plantuml_enabled
    # @option options [String] :plantuml_url
    # @option options [Float] :polling_interval_multiplier
    # @option options [Boolean] :project_export_enabled
    # @option options [Boolean] :prometheus_metrics_enabled
    # @option options [Boolean] :pseudonymizer_enabled
    # @option options [Boolean] :recaptcha_enabled
    # @option options [String] :recaptcha_private_key
    # @option options [String] :recaptcha_site_key
    # @option options [Boolean] :repository_checks_enabled
    # @option options [Integer] :repository_size_limit
    # @option options [Array<String>] :repository_storages
    # @option options [Boolean] :require_two_factor_authentication
    # @option options [Array<String>] :restricted_visibility_levels
    # @option options [Integer] :rsa_key_restriction
    # @option options [Boolean] :send_user_confirmation_email
    # @option options [String] :sentry_dsn
    # @option options [Boolean] :sentry_enabled
    # @option options [Integer] :session_expire_delay
    # @option options [Boolean] :shared_runners_enabled
    # @option options [Integer] :shared_runners_minutes
    # @option options [String] :shared_runners_text
    # @option options [String] :sign_in_text
    # @option options [String] :signin_enabled
    # @option options [Boolean] :signup_enabled
    # @option options [Boolean] :slack_app_enabled
    # @option options [String] :slack_app_id
    # @option options [String] :slack_app_secret
    # @option options [String] :slack_app_verification_token
    # @option options [Integer] :terminal_max_session_time
    # @option options [String] :terms
    # @option options [Boolean] :throttle_authenticated_api_enabled
    # @option options [Integer] :throttle_authenticated_api_period_in_seconds
    # @option options [Integer] :throttle_authenticated_api_requests_per_period
    # @option options [Boolean] :throttle_authenticated_web_enabled
    # @option options [Integer] :throttle_authenticated_web_period_in_seconds
    # @option options [Integer] :throttle_authenticated_web_requests_per_period
    # @option options [Boolean] :throttle_unauthenticated_enabled
    # @option options [Integer] :throttle_unauthenticated_period_in_seconds
    # @option options [Integer] :throttle_unauthenticated_requests_per_period
    # @option options [Integer] :two_factor_grace_period
    # @option options [Boolean] :unique_ips_limit_enabled
    # @option options [Integer] :unique_ips_limit_per_user
    # @option options [Integer] :unique_ips_limit_time_window
    # @option options [Boolean] :usage_ping_enabled
    # @option options [Boolean] :user_default_external
    # @option options [Boolean] :user_oauth_applications
    # @option options [Boolean] :user_show_add_ssh_key_message
    # @option options [Boolean] :version_check_enabled
    # @option options [Integer] :local_markdown_version
    # @option options [String] :geo_node_allowed_ips
    #
    # @return [Array<Gitlab::ObjectifiedHash>]
    def edit_application_settings(options = {})
      put('/application/settings', body: options)
    end
  end
end
