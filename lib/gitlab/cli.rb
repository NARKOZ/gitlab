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
    command = args.shift.strip rescue 'help'
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
  def self.run(cmd, args=[])
    case cmd
    when 'help'
      puts help(args.shift) { |out| out.gsub!(/Gitlab\./, 'gitlab ') }
    when 'info'
      endpoint = Gitlab.endpoint ? Gitlab.endpoint : 'not set'
      private_token = Gitlab.private_token ? Gitlab.private_token : 'not set'
      puts "Gitlab endpoint is #{endpoint}"
      puts "Gitlab private token is #{private_token}"
      puts "Ruby Version is #{RUBY_VERSION}"
      puts "Gitlab Ruby Gem #{Gitlab::VERSION}"
    when '-v', '--version'
      puts "Gitlab Ruby Gem #{Gitlab::VERSION}"
    when 'shell'
      Gitlab::Shell.start
    else
      unless valid_command?(cmd)
        puts "Unknown command. Run `gitlab help` for a list of available commands."
        exit(1)
      end

      if args.any? && (args.last.start_with?('--only=') || args.last.start_with?('--except='))
        command_args = args[0..-2]
      else
        command_args = args
      end

      begin
        yaml_load_arguments! command_args
        command_args.map! {|arg| symbolize_keys arg }
      rescue => e
        puts e.message
        exit 1
      end

      confirm_command(cmd)

      data = gitlab_helper(cmd, command_args) { exit(1) }
      output_table(cmd, args, data)
    end
  end
end
