# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Shell do
  before do
    described_class.setup
  end

  describe '.execute' do
    context 'invalid command' do
      it 'raises RuntimeError' do
        expect { described_class.execute 'foobar', [] }.to raise_error(RuntimeError)
      end
    end
  end

  describe '.history' do
    before do
      @history = described_class.history
    end

    it 'returns a Gitlab::Shell::History instance' do
      expect(@history).to be_a Gitlab::Shell::History
    end
    it 'responds to :save' do
      expect(@history).to respond_to :save
    end
    it 'responds to :load' do
      expect(@history).to respond_to :load
    end
    it 'responds to :<<' do
      expect(@history).to respond_to :<<
    end
  end

  describe '.setup' do
    it 'sets the Readline completion_proc' do
      completion = Readline.completion_proc
      expect(completion).to be_truthy
      expect(completion).to be_a Proc
    end
    it 'sets the Readline completion_append_character' do
      completion_character = Readline.completion_append_character
      expect(completion_character).to eq(' ')
    end
  end

  describe '.completion' do
    before do
      @comp = described_class.completion
    end

    it 'returns a Proc object' do
      expect(@comp).to be_a Proc
    end
    context 'called with an argument' do
      it 'returns an Array of matching commands' do
        completed_cmds = @comp.call 'issue'
        expect(completed_cmds).to be_a Array
        expect(completed_cmds.sort).to eq(%w[issue issue_label_event issue_label_events issue_note issue_notes issues])
      end
    end
  end

  describe '.parse_input' do
    context 'with arguments' do
      it 'sets command & arguments' do
        described_class.parse_input('create_branch 1 "api" "master"')
        expect(described_class.command).to eq('create_branch')
        expect(described_class.arguments).to eq(%w[1 api master])
      end
    end

    context 'without arguments' do
      it 'sets command & empty arguments' do
        described_class.parse_input('exit')
        expect(described_class.command).to eq('exit')
        expect(described_class.arguments).to be_empty
      end
    end
  end
end
