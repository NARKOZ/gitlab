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
      puts Gitlab.actions.sort.join(', ')
    when '-v', '--version'
      puts "Gitlab Ruby Gem #{Gitlab::VERSION}"
    else
      if Gitlab.actions.include?(cmd.to_sym)
        begin
          data = arguments.any? ? Gitlab.send(cmd.to_sym, *arguments) : Gitlab.send(cmd.to_sym)
          output_styled_hash(data.to_h, cmd, arguments)
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

  def self.output_styled_hash(hash, cmd, args)
    keys = hash.keys.sort {|x, y| x.to_s <=> y.to_s }
    max_key_length = hash.keys.map {|k| k.to_s.size }.max
    max_value_length = hash.values.map {|v| v.to_s.size }.max

    keys.each_with_index do |key, index|
      separator = '+' + '-' * (max_value_length + max_key_length + 5) + '+'

      # print executed command
      if index == 0
        puts separator
        print "| ".ljust(max_key_length)
        print "Gitlab.#{cmd} #{args.join(', ')}"
        puts ' |'.rjust(max_value_length) # FIXME
      end

      case value = hash[key]
      when Array
        # TODO: handle
        next
      when Hash
        # TODO: handle
        next
      when nil
        next
      else


        # print returned data
        puts separator
        print "| #{key}".ljust(max_key_length + 3)
        print "| #{value}"
        puts ' |'.rjust(max_value_length - value.to_s.size + 2)
        puts separator if keys.size - 1 == index
      end
    end
  end
end
