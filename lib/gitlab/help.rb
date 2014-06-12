require 'gitlab'
require_relative 'cli_helpers'

module Gitlab::Help
  extend Gitlab::CLI::Helpers

  def self.get_help(methods,cmd=nil)
    if cmd.nil? || cmd === 'help'
      puts actions_table
    else
      namespace = methods.select {|m| m[:name] === cmd }.map {|m| m[:owner]+'.'+m[:name] }.shift
      if namespace
        begin
          puts `ri -T #{namespace}`
        rescue => e
          puts  e.message
        end
      else
        puts "Unknown command: #{cmd}"
      end
    end
  end
end
