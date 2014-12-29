require 'yaml'

class Gitlab::CLI
  # Defines methods related to CLI output and formatting.
  module Helpers
    extend self

    # Returns actions available to CLI & Shell
    #
    # @return [Array]
    def actions
      @actions ||= Gitlab.actions
    end

    # Returns Gitlab::Client instance
    #
    # @return [Gitlab::Client]
    def client
      @client ||= Gitlab::Client.new(endpoint: (Gitlab.endpoint || ''))
    end

    # Returns method names and their owners
    #
    # @return [Array<Hash>]
    def method_owners
      @method_owners ||= actions.map do |action|
        {
          name: action.to_s,
          owner: client.method(action).owner.to_s
        }
      end
    end

    # Returns filtered required fields.
    #
    # @return [Array]
    def required_fields(args)
      if args.any? && args.last.is_a?(String) && args.last.start_with?('--only=')
        args.last.gsub('--only=', '').split(',')
      else
        []
      end
    end

    # Returns filtered excluded fields.
    #
    # @return [Array]
    def excluded_fields(args)
      if args.any? && args.last.is_a?(String) && args.last.start_with?('--except=')
        args.last.gsub('--except=', '').split(',')
      else
        []
      end
    end

    # Confirms command is valid.
    #
    # @return [Boolean]
    def valid_command?(cmd)
      command = cmd.is_a?(Symbol) ? cmd : cmd.to_sym
      Gitlab.actions.include?(command)
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
      owners = method_owners.map {|m| m[:owner].gsub('Gitlab::Client::','')}.uniq.sort
      methods_c = method_owners.group_by {|m| m[:owner]}
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

    # Outputs a nicely formatted table or error msg.
    #
    # @return [String]
    def output_table(cmd, args, data)
      case data
      when Gitlab::ObjectifiedHash
        puts record_table([data], cmd, args)
      when Array
        puts record_table(data, cmd, args)
      else  # probably just an error msg
        puts data
      end
    end

    # Table to display records.
    #
    # @return [String]
    def record_table(data, cmd, args)
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

    # Helper function to call Gitlab commands with args.
    def gitlab_helper(cmd, args=[])
      begin
        data = args.any? ? Gitlab.send(cmd, *args) : Gitlab.send(cmd)
      rescue => e
        puts e.message
        yield if block_given?
      end

      data
    end

    # Convert a hash (recursively) to use symbol hash keys
    # @return [Hash]
    def symbolize_keys(hash)
      if hash.is_a?(Hash)
        hash = hash.each_with_object({}) do |(key, value), newhash|
          begin
            newhash[key.to_sym] = symbolize_keys(value)
          rescue NoMethodError
            puts "error: cannot convert hash key to symbol: #{key}"
            raise
          end
        end
      end

      hash
    end

    # Run YAML::load on each arg.
    # @return [Array]
    def yaml_load_arguments!(args)
      args.map! do |arg|
        begin
          arg = YAML::load(arg)
        rescue Psych::SyntaxError
          puts "error: Argument is not valid YAML syntax: #{arg}"
          raise
        end

        arg
      end
    end
  end
end
