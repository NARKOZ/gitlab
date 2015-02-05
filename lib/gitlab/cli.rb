require 'gitlab'
require 'terminal-table/import'
require_relative 'cli_helpers'
require_relative 'shell'

class Gitlab::CLI
  extend Helpers

  def self.start(args)
    command = args.shift.strip rescue 'help'
    run(command, args)
  end

  def self.run(cmd, args=[])
    case cmd
    when 'help'
      puts actions_table
    when 'info'
      endpoint = Gitlab.endpoint ? Gitlab.endpoint : 'not set'
      private_token = Gitlab.private_token ? Gitlab.private_token : 'not set'
      auth_token = Gitlab.auth_token ? Gitlab.auth_token : 'not set'
      puts "Gitlab endpoint is #{endpoint}"
      puts "Gitlab private token is #{private_token}"
      puts "Gitlab auth token is #{auth_token}"
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
