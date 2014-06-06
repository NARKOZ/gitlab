require 'gitlab'
require "readline"
require_relative 'cli_helpers'

class Gitlab::Shell
  extend Gitlab::CLI::Helpers

  def self.start
    actions = Gitlab.actions.map(&:to_s)
    actions << 'endpoint=' << 'private_token='

    comp = proc { |s| actions.grep(/^#{Regexp.escape(s)}/) }

    Readline.completion_append_character = " "
    Readline.completion_proc = comp

    while buf = Readline.readline("gitlab> ", true)
      next if buf.nil? || buf.empty?
      buf = buf.split.map(&:chomp)
      cmd = buf.shift
      args = buf.count > 0 ? buf : [] 
      confirm_command(cmd)

      data = gitlab_helper(cmd,args)
      
      output_table(cmd, args, data)
    end
  end
end
