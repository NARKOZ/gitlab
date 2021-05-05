# frozen_string_literal: true

require 'httparty'
require 'json'
require 'gitlab/client/version'
require 'gitlab/client/objectified_hash'
require 'gitlab/client/configuration'
require 'gitlab/client/error'
require 'gitlab/client/page_links'
require 'gitlab/client/paginated_response'
require 'gitlab/client/file_response'

module Gitlab
  # Wrapper for the Gitlab REST API.
  class Client # rubocop:disable Metrics/ClassLength
    extend Configuration

    Dir[File.expand_path('client/*.rb', __dir__)].each { |f| require f }

    # Please keep in alphabetical order
    include AccessRequests
    include ApplicationSettings
    include Avatar
    include AwardEmojis
    include Boards
    include Branches
    include BroadcastMessages
    include BuildVariables
    include Builds
    include Commits
    include ContainerRegistry
    include Deployments
    include Environments
    include EpicIssues
    include Epics
    include Events
    include Features
    include GroupBadges
    include GroupBoards
    include GroupLabels
    include GroupMilestones
    include Groups
    include IssueLinks
    include Issues
    include Jobs
    include Keys
    include Labels
    include Lint
    include Markdown
    include MergeRequestApprovals
    include MergeRequests
    include Milestones
    include Namespaces
    include Notes
    include PipelineSchedules
    include PipelineTriggers
    include Pipelines
    include ProjectBadges
    include ProjectClusters
    include ProjectReleaseLinks
    include ProjectReleases
    include Projects
    include ProtectedTags
    include Repositories
    include RepositoryFiles
    include RepositorySubmodules
    include ResourceLabelEvents
    include ResourceStateEvents
    include Runners
    include Search
    include Services
    include Sidekiq
    include Snippets
    include SystemHooks
    include Tags
    include Templates
    include Todos
    include Users
    include UserSnippets
    include Versions
    include Wikis

    attr_accessor(:private_token, :endpoint, *Configuration::VALID_OPTIONS_KEYS)
    # @private
    alias auth_token= private_token=

    # Creates a new API.
    # @raise [Error:MissingCredentials]
    def initialize(config = {})
      config = self.class.config.merge(config)
      (Configuration::VALID_OPTIONS_KEYS + [:auth_token]).each do |key|
        send("#{key}=", config[key]) if config[key]
      end
      request_defaults(sudo)
      self.class.headers 'User-Agent' => user_agent
    end

    # Alias for Gitlab::Client.new
    #
    # @return [Gitlab::Client]
    def self.client(config = {})
      new(config)
    end

    # Text representation of the client, masking private token.
    #
    # @return [String]
    def inspect
      super.sub @private_token, only_show_last_four_chars(@private_token) if @private_token
    end

    # Utility method for URL encoding of a string.
    # Copied from https://ruby-doc.org/stdlib-2.7.0/libdoc/erb/rdoc/ERB/Util.html
    #
    # @return [String]
    def url_encode(url)
      url.to_s.b.gsub(/[^a-zA-Z0-9_\-.~]/n) { |m| sprintf('%%%02X', m.unpack1('C')) } # rubocop:disable Style/FormatString
    end

    # Returns an unsorted array of available client methods.
    #
    # @return [Array<Symbol>]
    def self.actions
      hidden = /endpoint|(private|auth)_token|user_agent|sudo|get|post|put|\Adelete\z|validate\z|request_defaults|httparty/
      (Gitlab::Client.instance_methods - Object.methods).reject { |e| e[hidden] }
    end

    # Delegate to Gitlab::Client
    def self.method_missing(method, *args, &block)
      Gitlab::Client.client.respond_to?(method) ? Gitlab::Client.client.send(method, *args, &block) : super
    end

    # Delegate to Gitlab::Client
    def self.respond_to_missing?(method_name, include_private = false)
      Gitlab::Client.client.respond_to?(method_name, include_private) || super
    end

    include HTTParty
    format :json
    headers 'Accept' => 'application/json', 'Content-Type' => 'application/x-www-form-urlencoded'
    parser(proc { |body, _| parse(body) })

    # Converts the response body to an ObjectifiedHash.
    def self.parse(body)
      body = body.nil? || body.empty? ? false : decode(body)

      if body.is_a? Hash
        ObjectifiedHash.new body
      elsif body.is_a? Array
        PaginatedResponse.new(body.collect! { |e| ObjectifiedHash.new(e) })
      else
        body ? true : false
      end
    end

    # Decodes a JSON response into Ruby object.
    def self.decode(response)
      response ? JSON.parse(response) : {}
    rescue JSON::ParserError
      raise Error::Parsing, 'The response is not a valid JSON'
    end

    %w[get post put delete].each do |method|
      define_method method do |path, options = {}|
        params = options.dup

        httparty_config(params)

        unless params[:unauthenticated]
          params[:headers] ||= {}
          params[:headers].merge!(authorization_header)
        end

        validate self.class.send(method, @endpoint + path, params)
      end
    end

    # Checks the response code for common errors.
    # Returns parsed response for successful requests.
    def validate(response)
      raise Error::STATUS_MAPPINGS[response.code], response if Error::STATUS_MAPPINGS[response.code]

      parsed = response.parsed_response
      parsed.client = self if parsed.respond_to?(:client=)
      parsed.parse_headers!(response.headers) if parsed.respond_to?(:parse_headers!)
      parsed
    end

    # Sets a base_uri and default_params for requests.
    # @raise [Error::MissingCredentials] if endpoint not set.
    def request_defaults(sudo = nil)
      raise Error::MissingCredentials, 'Please set an endpoint to API' unless @endpoint

      self.class.default_params sudo ? { sudo: sudo } : {}
    end

    # Returns an Authorization header hash
    #
    # @raise [Error::MissingCredentials] if private_token and auth_token are not set.
    def authorization_header
      raise Error::MissingCredentials, 'Please provide a private_token or auth_token for user' unless @private_token

      if @private_token.size < 21
        { 'PRIVATE-TOKEN' => @private_token }
      else
        { 'Authorization' => "Bearer #{@private_token}" }
      end
    end

    # Set HTTParty configuration
    # @see https://github.com/jnunemaker/httparty
    def httparty_config(options)
      options.merge!(httparty) if httparty
    end

    def only_show_last_four_chars(token)
      "#{'*' * (token.size - 4)}#{token[-4..-1]}"
    end
  end
end
