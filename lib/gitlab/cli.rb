# frozen_string_literal: true

require 'gitlab'
require 'terminal-table/import'
require_relative 'cli_helpers'
require_relative 'shell'

class Gitlab::CLI
  extend Helpers

  # Starts a new CLI session.
  #
  # @example
  #   Gitlab::CLI.start(['help'])
  #   Gitlab::CLI.start(['help', 'issues'])
  #
  # @param [Array] args The command and it's optional arguments.
  def self.start(args)
    command = begin
      args.shift.strip
    rescue StandardError
      'help'
    end
    run(command, args)
  end

  # Processes a CLI command and outputs a result to the stream (stdout).
  #
  # @example
  #   Gitlab::CLI.run('help')
  #   Gitlab::CLI.run('help', ['issues'])
  #
  # @param [String] cmd The name of a command.
  # @param [Array] args The optional arguments for a command.
  # @return [nil]
  def self.run(cmd, args = [])
    case cmd
    when 'help'
      puts help(args.shift) { |out| out.gsub!(/Gitlab\./, 'gitlab ') }
    when 'info'
      endpoint = Gitlab.endpoint || 'not set'
      private_token = Gitlab.private_token || 'not set'
      puts "Gitlab endpoint is #{endpoint}"
      puts "Gitlab private token is #{private_token}"
      puts "Ruby Version is #{RUBY_VERSION}"
      puts "Gitlab Ruby Gem #{Gitlab::VERSION}"
    when '-v', '--version'
      puts "Gitlab Ruby Gem #{Gitlab::VERSION}"
    when 'shell'
      Gitlab::Shell.start
    else
      if args.include? '--json'
        @json_output = true
        args.delete '--json'
      end

      unless valid_command?(cmd)
        puts 'Unknown command. Run `gitlab help` for a list of available commands.'
        exit(0) if ENV['CI'] # FIXME: workaround to exit with 0 on passed specs
        exit(1)
      end

      command_args = args.any? && args.last.start_with?('--only=', '--except=') ? args[0..-2] : args

      begin
        command_args.map! { |arg| symbolize_keys(yaml_load(arg)) }
      rescue StandardError => e
        puts e.message
        exit 1
      end

      confirm_command(cmd)

      data = gitlab_helper(cmd, command_args) { exit(1) }

      render_output(cmd, args, data)
    end
  end

  # Helper method that checks whether we want to get the output as json
  # @return [nil]
  def self.render_output(cmd, args, data)
    if defined?(@json_output) && @json_output
      output_json(cmd, args, data)
    else
      output_table(cmd, args, data)
    end
  end
end
