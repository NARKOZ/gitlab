require 'spec_helper'

describe Gitlab::Shell do
  describe ".history" do
    it "should return a Gitlab::Shell::History instance" do
      history = Gitlab::Shell.history
      expect(history).to be_a Gitlab::Shell::History
    end
  end

  describe ".setup" do
    before(:all) do
      Gitlab::Shell.setup
    end
    it "should create an instance of Gitlab::Client in class variable 'client'" do
      expect(Gitlab::Shell.client).to be_a Gitlab::Client
    end
    it "should set array of @actions" do
      expect(Gitlab::Shell.actions).to be_a Array
      expect(Gitlab::Shell.actions.sort).to eq(Gitlab.actions.sort)
    end
    it "should set the Readline completion_proc" do
      completion = Readline.completion_proc
      expect(completion).to be_truthy
      expect(completion).to be_a Proc
    end
    it "should set the Readline completion_append_character" do
      completion_character = Readline.completion_append_character
      expect(completion_character).to eq(' ')
    end
  end

  describe ".completion" do
    it "should return a Proc object" do
      comp = Gitlab::Shell.completion
      expect(comp).to be_a Proc
    end
  end

  describe ".parse_input" do
    context "with arguments" do
      it "should set command & arguements" do
        Gitlab::Shell.parse_input('create_branch 1 "api" "master"') 
        expect(Gitlab::Shell.command).to eq('create_branch')
        expect(Gitlab::Shell.arguments).to eq(['1', 'api', 'master'])
      end
    end
      
    context "without arguments" do
      it 'should set command & empty arguments' do
        Gitlab::Shell.parse_input('exit') 
        expect(Gitlab::Shell.command).to eq('exit')
        expect(Gitlab::Shell.arguments).to be_empty
      end
    end
  end
end
