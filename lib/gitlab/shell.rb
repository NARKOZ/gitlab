require 'gitlab'
require 'gitlab/help'
require 'gitlab/cli_helpers'
require 'readline'

class Gitlab::Shell
  extend Gitlab::CLI::Helpers

  def self.start
    actions = Gitlab.actions

    comp = proc { |s| actions.map(&:to_s).grep(/^#{Regexp.escape(s)}/) }

    Readline.completion_proc = comp
    Readline.completion_append_character = ' '

    client = Gitlab::Client.new(endpoint: '')

    while buf = Readline.readline('gitlab> ', true)
      next if buf.nil? || buf.empty?
      break if buf == 'exit'

      buf = buf.scan(/["][^"]+["]|\S+/).map { |word| word.gsub(/^['"]|['"]$/,'') }
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

        args[0].nil? ? Gitlab::Help.get_help(methods) : Gitlab::Help.get_help(methods, args[0])
        next
      end

      data = if actions.include?(cmd.to_sym)
        confirm_command(cmd)
        gitlab_helper(cmd, args)
      else
        "'#{cmd}' is not a valid command.  See the 'help' for a list of valid commands."
      end

      output_table(cmd, args, data)
    end
  end
end
