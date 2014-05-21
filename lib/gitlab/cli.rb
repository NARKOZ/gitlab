require 'gitlab'
require 'terminal-table/import'
require_relative 'cli_helpers'

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
      puts "Gitlab endpoint is #{endpoint}"
      puts "Gitlab private token is #{private_token}"
      puts "Ruby Version is #{RUBY_VERSION}"
      puts "Gitlab Ruby Gem #{Gitlab::VERSION}"
    when '-v', '--version'
      puts "Gitlab Ruby Gem #{Gitlab::VERSION}"
    else
      unless Gitlab.actions.include?(cmd.to_sym)
        puts "Unknown command. Run `gitlab help` for a list of available commands."
        exit(1)
      end

      if args.any? && (args.last.start_with?('--only=') || args.last.start_with?('--except='))
        command_args = args[0..-2]
      else
        command_args = args
      end

      confirm_command(cmd)

      begin
        data = args.any? ? Gitlab.send(cmd, *command_args) : Gitlab.send(cmd)
      rescue => e
        puts e.message
        exit(1)
      end

      case data
      when Gitlab::ObjectifiedHash
        puts single_record_table(data, cmd, args)
      when Array
        puts multiple_record_table(data, cmd, args)
      else
        puts data.inspect
      end
    end
  end
end
