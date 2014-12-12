require 'gitlab'
require 'gitlab/help'
require 'gitlab/cli_helpers'
require 'gitlab/shell_history'
require 'readline'
require 'shellwords'

class Gitlab::Shell
  extend Gitlab::CLI::Helpers

  # Start gitlab shell and run infinite loop waiting for user input
  def self.start
    history.load
    actions = Gitlab.actions

    comp = proc { |s| actions.map(&:to_s).grep(/^#{Regexp.escape(s)}/) }

    Readline.completion_proc = comp
    Readline.completion_append_character = ' '

    client = Gitlab::Client.new(endpoint: '')

    while buf = Readline.readline('gitlab> ')
      next if buf.nil? || buf.empty?
      quit_shell if buf == 'exit'

      history << buf

      begin
        buf = Shellwords.shellwords(buf)
      rescue ArgumentError => e
        puts e.message
        next
      end

      cmd = buf.shift
      args = buf.count > 0 ? buf : []

      if cmd == 'help'
        methods = []

        actions.each do |action|
          methods << {
            name: action.to_s,
            owner: client.method(action).owner.to_s
          }
        end

        args[0].nil? ? Gitlab::Help.get_help(methods) :
                       Gitlab::Help.get_help(methods, args[0])
        next
      end

      syntax_errors = false

      begin
        yaml_load_and_symbolize_hash!(args)
      rescue
        syntax_errors = true
      end

      # errors have been displayed, return to the prompt
      next if syntax_errors 

      data = if actions.include?(cmd.to_sym)
        confirm_command(cmd)
        gitlab_helper(cmd, args)
      else
        "'#{cmd}' is not a valid command. " +
        "See the 'help' for a list of valid commands."
      end

      output_table(cmd, args, data)
    end
  end

  def self.quit_shell
    history.save
    exit
  end

  def self.history
    @history ||= History.new
  end
end
