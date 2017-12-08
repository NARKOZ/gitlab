require 'spec_helper'

describe Gitlab::Shell do
  before do
    Gitlab::Shell.setup
  end

  describe ".execute" do
    context "invalid command" do
      it "raises RuntimeError" do
        expect { Gitlab::Shell.execute 'foobar', [] }.to raise_error(RuntimeError)
      end
    end
  end

  describe ".history" do
    before do
      @history = Gitlab::Shell.history
    end

    it "returns a Gitlab::Shell::History instance" do
      expect(@history).to be_a Gitlab::Shell::History
    end
    it "responds to :save" do
      expect(@history).to respond_to :save
    end
    it "responds to :load" do
      expect(@history).to respond_to :load
    end
    it "responds to :<<" do
      expect(@history).to respond_to :<<
    end
  end

  describe ".setup" do
    it "sets the Readline completion_proc" do
      completion = Readline.completion_proc
      expect(completion).to be_truthy
      expect(completion).to be_a Proc
    end
    it "sets the Readline completion_append_character" do
      completion_character = Readline.completion_append_character
      expect(completion_character).to eq(' ')
    end
  end

  describe ".completion" do
    before do
      @comp = Gitlab::Shell.completion
    end
    it "returns a Proc object" do
      expect(@comp).to be_a Proc
    end
    context "called with an argument" do
      it "returns an Array of matching commands" do
        completed_cmds = @comp.call 'group'
        expect(completed_cmds).to be_a Array
        expect(completed_cmds.sort).to eq(%w(group group_member group_members group_projects group_search group_subgroups group_variable group_variables groups))
      end
    end
  end

  describe ".parse_input" do
    context "with arguments" do
      it "sets command & arguments" do
        Gitlab::Shell.parse_input('create_branch 1 "api" "master"')
        expect(Gitlab::Shell.command).to eq('create_branch')
        expect(Gitlab::Shell.arguments).to eq(%w(1 api master))
      end
    end

    context "without arguments" do
      it 'sets command & empty arguments' do
        Gitlab::Shell.parse_input('exit')
        expect(Gitlab::Shell.command).to eq('exit')
        expect(Gitlab::Shell.arguments).to be_empty
      end
    end
  end
end
