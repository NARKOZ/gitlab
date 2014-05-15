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
          if data.kind_of? Gitlab::ObjectifiedHash
            puts single_table_output(data, cmd, arguments)
          elsif data.kind_of? Array
            puts multiple_table_output(data, cmd, arguments)
          end
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

  def self.multiple_table_output(data, cmd, args)
    return 'No data' if data.empty?

    arr = data.map(&:to_h)
    keys = arr.first.keys.sort {|x, y| x.to_s <=> y.to_s }

    table do |t|
      t.title = "Gitlab.#{cmd} #{args.join(', ')}"
      t.headings = keys

      arr.each_with_index do |hash, index|
        values = []

        keys.each do |key|
          case value = hash[key]
          when Hash
            value = 'Hash'
          when nil
            value = 'null'
          end

          values << value
        end

        t.add_row values
        t.add_separator unless arr.size - 1 == index
      end
    end
  end

  def self.single_table_output(data, cmd, args)
    hash = data.to_h
    keys = hash.keys.sort {|x, y| x.to_s <=> y.to_s }

    table do |t|
      t.title = "Gitlab.#{cmd} #{args.join(', ')}"

      keys.each_with_index do |key, index|
        case value = hash[key]
        when Hash
          value = 'Hash'
        when nil
          value = 'null'
        end

        t.add_row [key, value]
        t.add_separator unless keys.size - 1 == index
      end
    end
  end
end
