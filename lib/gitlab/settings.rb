require 'yaml'

module Gitlab
  module Configuration
    class Settings
      # The user agent that will be sent to the API endpoint if none is set.
      DEFAULT_USER_AGENT = "Gitlab Ruby Gem #{Gitlab::VERSION}".freeze

      # by default we look in the environment variable for the config file name in case the user
      # wants to switch servers, otherwise we always looking ~/.gitlab_cli/gitlab_cli_config.yml
      def config_file
        @config_file ||= ENV['GITLAB_CONFIG_FILE'] || 'gitlab_cli_config.yml'
      end

      def settings_path
        @settings_path ||= File.expand_path(File.join('~', '.gitlab_cli', config_file))
      end

      def file_config
        begin
          if File.exists?(settings_path)
            @settings ||= YAML.load_file(settings_path) || {}
            raise "Invalid Config file" unless @settings.instance_of?(Hash)
          else
            @settings = {}
          end
        rescue Exception => e
          raise "Unable to load gitlab cli config file at #{settings_path}\n #{e.message}"
        end
        @settings
      end

      def sudo
        file_config[:sudo]
      end

      def user_agent
        file_config[:user_agent] || DEFAULT_USER_AGENT
      end

      def endpoint
        ENV['GITLAB_API_ENDPOINT'] || file_config[:gitlab_api_endpoint]
      end

      def private_token
        ENV['GITLAB_API_PRIVATE_TOKEN'] || file_config[:gitlab_private_token]
      end

      def http_party

      end

      def http_proxy
        file_config[:http_proxy]
      end

      def proxy_username
        file_config[:proxy_username]
      end

      def proxy_password
        file_config[:proxy_password]
      end

      def self.config
        Gitlab::Configuration::Settings.new
      end
    end
  end
end
