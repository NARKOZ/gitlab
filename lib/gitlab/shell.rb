require 'gitlab'
require 'gitlab/help'
require 'gitlab/cli_helpers'
require 'gitlab/shell_history'
require 'readline'
require 'shellwords'

class Gitlab::Shell
  extend Gitlab::CLI::Helpers

  class << self
    attr_reader :arguments, :command

    def start
      setup

      while buffer = Readline.readline('gitlab> ')
        trap('INT') { quit_shell } # capture ctrl-c
        
        begin
          parse_input buffer

          yaml_load_arguments! @arguments
          @arguments.map! { |arg| symbolize_keys arg }

          case buffer
          when nil, ''
            next
          when 'exit'
            quit_shell
          when /^\bhelp\b+/
            puts help arguments[0]
          else
            history << buffer

            data = execute command, arguments
            output_table command, arguments, data
          end
        rescue => e
          puts e.message
        end
      end

      quit_shell # save history if user presses ctrl-d
    end

    def parse_input(buffer)
      buf = Shellwords.shellwords(buffer)

      @command = buf.shift
      @arguments = buf.count > 0 ? buf : []
    end

    def setup
      history.load

      Readline.completion_proc = completion
      Readline.completion_append_character = ' '
    end

    # Gets called when user hits TAB key to do completion
    def completion
      proc { |str| actions.map(&:to_s).grep(/^#{Regexp.escape(str)}/) }
    end

    def help(cmd = nil)
      cmd.nil? ? actions_table : Gitlab::Help.get_help(cmd)
    end

    # Execute a given command with arguements
    def execute(cmd = command, args = arguments)
      if actions.include?(cmd.to_sym)
        confirm_command(cmd)
        gitlab_helper(cmd, args)
      else
        raise "Unknown command: #{cmd}. " +
              "See the 'help' for a list of valid commands."
      end
    end

    def quit_shell
      history.save
      exit
    end

    def history
      @history ||= History.new
    end

  end  # class << self
end
