require 'gitlab'
require 'gitlab/cli_helpers'

module Gitlab::Help
  extend Gitlab::CLI::Helpers

  def self.get_help(methods,cmd)
    help = ''

    ri_cmd = `which ri`.chomp

    if $? == 0
      namespace = methods.select {|m| m[:name] === cmd }.
                          map {|m| m[:owner]+'.'+m[:name] }.shift

      if namespace
        begin
          ri_output = `#{ri_cmd} -T #{namespace} 2>&1`.chomp

          if $? == 0
            ri_output.gsub!(/#{cmd}\((.*?)\)/m, cmd+' \1')
            ri_output.gsub!(/Gitlab\./, 'gitlab> ')
            ri_output.gsub!(/Gitlab\..+$/, '')
            ri_output.gsub!(/\,[\s]*/, ' ')
            help = ri_output
          else
            help = "Ri docs not found for #{namespace}, please install the docs to use 'help'."
          end
        rescue => e
          puts e.message
        end
      else
        help = "Unknown command: #{cmd}."
      end
    else
      help = "'ri' tool not found in your PATH, please install it to use the help."
    end

    help
  end
end
