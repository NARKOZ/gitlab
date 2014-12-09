require 'spec_helper'
require 'tempfile'

describe Gitlab::Shell::History do
  context 'saving to a file' do
    before do
      @file = Tempfile.new('.gitlab_shell_history')
      @history = Gitlab::Shell::History.new(file_path: @file.path)
    end

    after do @file.close(true) end

    it 'saves the lines' do
      @history.save('party on, dudes')
      @history.save('be excellent to each other')
      expect(File.read @file.path).
        to eq("party on, dudes\nbe excellent to each other\n")
    end

    it 'has the lines' do
      @history.save('party on, dudes')
      @history.save('be excellent to each other')
      expect(@history.lines).
        to eq(["party on, dudes", "be excellent to each other"])
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
