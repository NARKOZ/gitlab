require 'spec_helper'

describe Gitlab::Help do

  describe ".ri_cmd" do
    context "ri command found" do
      it "should return the path to RI" do
        allow(Gitlab::Help).to receive(:`).with(/which ri/).and_return('/usr/bin/ri')
        expect(Gitlab::Help.ri_cmd).to eq('/usr/bin/ri')
      end
    end

    context "ri command NOT found" do
      it "should raise" do
        allow(Gitlab::Help).to receive(:`).with(/which ri/).and_return('')
        expect{Gitlab::Help.ri_cmd}.to raise_error
      end
    end

  end

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
