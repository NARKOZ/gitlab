require 'gitlab'
require 'terminal-table/import'

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
      puts Gitlab.actions.sort.join(', ')
    when '-v', '--version'
      puts "Gitlab Ruby Gem #{Gitlab::VERSION}"
    else
      if Gitlab.actions.include?(cmd.to_sym)
        begin
          data = arguments.any? ? Gitlab.send(cmd.to_sym, *arguments) : Gitlab.send(cmd.to_sym)
          puts table_output(data.to_h, cmd, arguments)
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

  def self.table_output(hash, cmd, args)
    keys = hash.keys.sort {|x, y| x.to_s <=> y.to_s }

    table do |t|
      t.title = "Gitlab.#{cmd} #{args.join(', ')}"

      keys.each_with_index do |key, index|
        case value = hash[key]
        when Array
          # TODO
          next
        when Hash
          # TODO
          next
        when nil
          value = 'null'
        end

        t.add_row [key, value]
        t.add_separator unless keys.size - 1 == index
      end
    end
  end
end
