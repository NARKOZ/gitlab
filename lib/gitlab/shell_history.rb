# frozen_string_literal: true

class Gitlab::Shell
  class History
    DEFAULT_HISTFILESIZE = 200
    DEFAULT_FILE_PATH = File.join(Dir.home, '.gitlab_shell_history')

    def initialize(options = {})
      @file_path = options[:file_path] || DEFAULT_FILE_PATH
      Readline::HISTORY.clear
    end

    def load
      read_from_file { |line| Readline::HISTORY << line.chomp }
    end

    def save
      lines.each { |line| history_file&.puts line }
    end

    def push(line)
      Readline::HISTORY << line
    end
    alias << push

    def lines
      Readline::HISTORY.to_a.last(max_lines)
    end

    private

    def history_file
      @history_file ||= File.open(history_file_path, 'w', 0o600).tap do |file|
        file.sync = true
      end
    rescue Errno::EACCES
      warn 'History not saved; unable to open your history file for writing.'
      @history_file = false
    end

    def history_file_path
      File.expand_path(@file_path)
    end

    def read_from_file(&block)
      path = history_file_path

      File.foreach(path, &block) if File.exist?(path)
    rescue StandardError => e
      warn "History file not loaded: #{e.message}"
    end

    def max_lines
      (ENV['GITLAB_HISTFILESIZE'] || DEFAULT_HISTFILESIZE).to_i
    end
  end
end
