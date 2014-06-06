class Gitlab::CLI
  # Defines methods related to CLI output and formatting.
  module Helpers
    extend self

    # Returns filtered required fields.
    #
    # @return [Array]
    def required_fields(args)
      if args.any? && args.last.start_with?('--only=')
        args.last.gsub('--only=', '').split(',')
      else
        []
      end
    end

    # Returns filtered excluded fields.
    #
    # @return [Array]
    def excluded_fields(args)
      if args.any? && args.last.start_with?('--except=')
        args.last.gsub('--except=', '').split(',')
      else
        []
      end
    end

    # Confirms command with a desctructive action.
    #
    # @return [String]
    def confirm_command(cmd)
      if cmd.start_with?('remove_') || cmd.start_with?('delete_')
        puts "Are you sure? (y/n)"
        if %w(y yes).include?($stdin.gets.to_s.strip.downcase)
          puts 'Proceeding..'
        else
          puts 'Command aborted.'
          exit(1)
        end
      end
    end

    # Table with available commands.
    #
    # @return [String]
    def actions_table
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
      methods_c = Hash[methods_c.sort_by(&:first).map {|k, v| [k, v]}]
      max_column_length = methods_c.values.max_by(&:size).size

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

    # Decides which table to use.
    #
    # @return [String]

    def output_table(cmd, args, data)
      case data
      when Gitlab::ObjectifiedHash
        puts single_record_table(data, cmd, args)
      when Array
        puts multiple_record_table(data, cmd, args)
      else
        puts data.inspect
      end

    end

    # Table for a single record.
    #
    # @return [String]
    def single_record_table(data, cmd, args)
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

    # Table for multiple records.
    #
    # @return [String]
    def multiple_record_table(data, cmd, args)
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

    # Helper function to call Gitlab commands, w/ args
    def gitlab_helper(cmd,args=[])
      begin
        data = args.any? ? Gitlab.send(cmd, *args) : Gitlab.send(cmd)
      rescue => e
        puts e.message
        yield if block_given?
      end
      data
    end
  end
end
