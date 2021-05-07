# frozen_string_literal: true

require 'gitlab'
require 'gitlab/cli_helpers'

module Gitlab::Help
  extend Gitlab::CLI::Helpers

  class << self
    # Returns the (modified) help from the 'ri' command or returns an error.
    #
    # @return [String]
    def get_help(cmd)
      cmd_namespace = namespace cmd

      if cmd_namespace
        ri_output = `#{ri_cmd} -T #{cmd_namespace} 2>&1`.chomp

        if $CHILD_STATUS == 0
          change_help_output! cmd, ri_output
          yield ri_output if block_given?

          ri_output
        else
          "Ri docs not found for #{cmd}, please install the docs to use 'help'."
        end
      else
        "Unknown command: #{cmd}."
      end
    end

    # Finds the location of 'ri' on a system.
    #
    # @return [String]
    def ri_cmd
      which_ri = `which ri`.chomp
      raise "'ri' tool not found in $PATH. Please install it to use the help." if which_ri.empty?

      which_ri
    end

    # A hash map that contains help topics (Branches, Groups, etc.)
    # and a list of commands that are defined under a topic (create_branch,
    # branches, protect_branch, etc.).
    #
    # @return [Hash<Array>]
    def help_map
      @help_map ||=
        actions.each_with_object({}) do |action, hsh|
          key = client.method(action)
                      .owner.to_s.gsub(/Gitlab::(?:Client::)?/, '')
          hsh[key] ||= []
          hsh[key] << action.to_s
        end
    end

    # Table with available commands.
    #
    # @return [Terminal::Table]
    def actions_table(topic = nil)
      rows = topic ? help_map[topic] : help_map.keys
      table do |t|
        t.title = topic || 'Help Topics'

        # add_row expects an array and we have strings hence the map.
        rows.sort.map { |r| [r] }.each_with_index do |row, index|
          t.add_row row
          t.add_separator unless rows.size - 1 == index
        end
      end
    end

    # Returns full namespace of a command (e.g. Gitlab::Client::Branches.cmd)
    def namespace(cmd)
      method_owners.select { |method| method[:name] == cmd }
                   .map { |method| "#{method[:owner]}.#{method[:name]}" }
                   .shift
    end

    # Massage output from 'ri'.
    def change_help_output!(cmd, output_str)
      output_str = +output_str
      output_str.gsub!(/#{cmd}(\(.*?\))/m, "#{cmd}\\1")
      output_str.gsub!(/,\s*/, ', ')

      # Ensure @option descriptions are on a single line
      output_str.gsub!(/\n\[/, " \[")
      output_str.gsub!(/\s(@)/, "\n@")
      output_str.gsub!(/(\])\n(:)/, '\\1 \\2')
      output_str.gsub!(/(:.*)(\n)(.*\.)/, '\\1 \\3')
      output_str.gsub!(/\{(.+)\}/, '"{\\1}"')
    end
  end
end
