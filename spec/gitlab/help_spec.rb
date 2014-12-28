require 'spec_helper'

describe Gitlab::Help do

  describe ".change_help_output!" do
    before do
      @cmd = "create_branch"
      @help_output = "Gitlab.#{@cmd}(4, 'new-branch', 'master')"
    end
    it "should return a String of modified output" do
      Gitlab::Help.change_help_output! @cmd, @help_output
      expect(@help_output).to eq("gitlab> create_branch 4 'new-branch' 'master'")
    end
  end

  describe ".help_methods" do
    before do
      @methods = Gitlab::Help.help_methods
    end
    it "should return Array of Hashes containing method names and owners" do
      expect(@methods).to be_a Array
      expect(@methods.all? { |m| m.is_a? Hash} ).to be true
      expect(@methods.all? { |m| m.keys.sort === [:name, :owner]} ).to be true
    end
  end
  
  describe ".namespace" do
    before do
      @cmd = 'create_tag'
      @namespace = Gitlab::Help.namespace @cmd
    end
    it "should return the full namespace for a command" do
      expect(@namespace).to be_a String
      expect(@namespace).to eq("Gitlab::Client::Repositories.#{@cmd}")
    end
  end

end
