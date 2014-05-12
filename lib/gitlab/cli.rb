require 'gitlab'

class Gitlab::CLI
  def self.start(args)
    command = args.shift.strip rescue 'help'
    run(command, args)
  end

  def self.run(cmd, arguments=[])
    case cmd
    when 'help'
      puts 'Available commands:'
      puts '-' * 19
      puts Gitlab.actions.join(', ')
    when '-v', '--version'
      puts "Gitlab Ruby Gem #{Gitlab::VERSION}"
    else
      if Gitlab.actions.include?(cmd.to_sym)
        begin
          data = arguments.any? ? Gitlab.send(cmd.to_sym, *arguments) : Gitlab.send(cmd.to_sym)
          puts data.to_h
        rescue => e
          puts e.message
          exit(1)
        end
      else
        puts 'Unknown command'
        exit(1)
      end
    end
  end
end
