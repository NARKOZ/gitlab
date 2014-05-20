require 'gitlab'
require 'terminal-table/import'

class Gitlab::CLI
  def self.start(args)
    command = args.shift.strip rescue 'help'
    run(command, args)
  end

  def self.run(cmd, args=[])
    case cmd
    when 'help'
      puts actions_table
    when '-v', '--version'
      puts "Gitlab Ruby Gem #{Gitlab::VERSION}"
    else
      unless Gitlab.actions.include?(cmd.to_sym)
        puts "Unknown command. Run `gitlab help` for a list of available commands."
        exit(1)
      end

      if args.any? && (args.last.start_with?('--only=') || args.last.start_with?('--except='))
        command_args = args[0..-2]
      end

      begin
        data = args.any? ? Gitlab.send(cmd, *command_args) : Gitlab.send(cmd)
      rescue => e
        puts e.message
        exit(1)
      end

      if data.kind_of? Gitlab::ObjectifiedHash
        puts single_record_table(data, cmd, args)
      elsif data.kind_of? Array
        puts multiple_record_table(data, cmd, args)
      end
    end
  end

  def self.actions_table
    client = Gitlab::Client.new(endpoint: '')
    actions = Gitlab.actions
    methods = []

    actions.each do |action|
      methods << {
        name: action,
        owner: client.method(action).owner.to_s.gsub('Gitlab::Client::', '')
      }
    end

    owners = methods.map {|m| m[:owner]}.uniq.sort
    methods_c = methods.group_by {|m| m[:owner]}
    methods_c = methods_c.map {|_, v| [_, v.sort_by {|hv| hv[:name]}] }
    methods_c = methods_c.sort_by {|v| v.first}.to_h
    max_column_length = methods_c.values.max_by {|v| v.size}.size

    rows = max_column_length.times.map do |i|
      methods_c.keys.map do |key|
        methods_c[key][i] ? methods_c[key][i][:name] : ''
      end
    end

    table do |t|
      t.title = "Available commands (#{actions.size} total)"
      t.headings = owners

      rows.each do |row|
        t.add_row row
      end
    end
  end

  def self.required_fields(args)
    if args.any? && args.last.start_with?('--only=')
      args.last.gsub('--only=', '').split(',')
    else
      []
    end
  end

  def self.excluded_fields(args)
    if args.any? && args.last.start_with?('--except=')
      args.last.gsub('--except=', '').split(',')
    else
      []
    end
  end

  def self.multiple_record_table(data, cmd, args)
    return 'No data' if data.empty?

    arr = data.map(&:to_h)
    keys = arr.first.keys.sort {|x, y| x.to_s <=> y.to_s }
    keys = keys & required_fields(args) if required_fields(args).any?
    keys = keys - excluded_fields(args)

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

  def self.single_record_table(data, cmd, args)
    hash = data.to_h
    keys = hash.keys.sort {|x, y| x.to_s <=> y.to_s }
    keys = keys & required_fields(args) if required_fields(args).any?
    keys = keys - excluded_fields(args)

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
