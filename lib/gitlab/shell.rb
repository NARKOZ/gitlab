require 'gitlab'
require 'gitlab/help'
require "readline"
require_relative 'cli_helpers'

class Gitlab::Shell
  extend Gitlab::CLI::Helpers

  def self.start
    actions = Gitlab.actions

    comp = proc { |s| actions.map(&:to_s).grep(/^#{Regexp.escape(s)}/) }

    Readline.completion_append_character = " "
    Readline.completion_proc = comp

    client = Gitlab::Client.new(endpoint: '')

    while buf = Readline.readline("gitlab> ", true)
      next if buf.nil? || buf.empty?
      buf = buf.split.map(&:chomp)
      cmd = buf.shift
      args = buf.count > 0 ? buf : [] 

      if cmd === 'help'
        methods = []

        actions.each do |action|
          methods << {
            name: action.to_s,
            owner: client.method(action).owner.to_s
          }
        end
        args[0].nil? ? Gitlab::Help.get_help(methods) : Gitlab::Help.get_help(methods,args[0])
        next
      end
      data = if !actions.include?(cmd.to_sym)
        "'#{cmd}' is not a valid command.  See the 'help' for a list of valid commands."
      else
        confirm_command(cmd)
        gitlab_helper(cmd,args)
      end
      
      output_table(cmd, args, data)
    end
  end
end
