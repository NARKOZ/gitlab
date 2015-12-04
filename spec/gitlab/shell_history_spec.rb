require 'spec_helper'
require 'tempfile'

describe Gitlab::Shell::History do
  context 'saving to a file' do
    before do
      @file = Tempfile.new('.gitlab_shell_history')
      @history = Gitlab::Shell::History.new(file_path: @file.path)
    end

    after { @file.close(true) }

    it 'saves the lines' do
      @history << 'party on, dudes'
      @history << 'be excellent to each other'
      @history.save
      expect(File.read @file.path).
        to eq("party on, dudes\nbe excellent to each other\n")
    end

    it 'has the lines' do
      @history << 'party on, dudes'
      @history << 'be excellent to each other'
      expect(@history.lines).
        to eq(["party on, dudes", "be excellent to each other"])
    end

    it 'limits the lines to GITLAB_HISTFILESIZE' do
      ENV['GITLAB_HISTFILESIZE'] = '2'
      @history << 'bogus'
      @history << 'party on, dudes'
      @history << 'be excellent to each other'
      @history.save
      expect(@history.lines).
        to eq(["party on, dudes", "be excellent to each other"])
      expect(File.read @file.path).
        to eq("party on, dudes\nbe excellent to each other\n")
    end
  end

  context 'loading a file' do
    before do
      @file = load_fixture('shell_history')
      @history = Gitlab::Shell::History.new(file_path: @file.path)
    end

    it 'has the lines' do
      @history.load
      expect(@history.lines).
        to eq(["party on, dudes", "be excellent to each other"])
    end
  end
end
