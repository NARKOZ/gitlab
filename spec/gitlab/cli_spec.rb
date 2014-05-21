require 'spec_helper'

describe Gitlab::CLI do
  describe ".run" do
    context "when command is version" do
      it "should show gem version" do
        output = capture_output { Gitlab::CLI.run('-v') }
        expect(output).to eq("Gitlab Ruby Gem #{Gitlab::VERSION}\n")
      end
    end

    context "when command is info" do
      it "should show environment info" do
        output = capture_output { Gitlab::CLI.run('info') }
        expect(output).to include("Gitlab endpoint is")
        expect(output).to include("Gitlab private token is")
        expect(output).to include("Ruby Version is")
        expect(output).to include("Gitlab Ruby Gem")
      end
    end

    context "when command is help" do
      it "should show available actions" do
        output = capture_output { Gitlab::CLI.run('help') }
        expect(output).to include('Available commands')
        expect(output).to include('MergeRequests')
        expect(output).to include('team_members')
      end
    end

    context "when command is user" do
      before do
        stub_get("/user", "user")
        @output = capture_output { Gitlab::CLI.run('user') }
      end

      it "should show executed command" do
        expect(@output).to include('Gitlab.user')
      end

      it "should show user data" do
        expect(@output).to include('name')
        expect(@output).to include('John Smith')
      end
    end
  end

  describe ".start" do
    context "when command with excluded fields" do
      before do
        stub_get("/user", "user")
        args = ['user', '--except=id,email,name']
        @output = capture_output { Gitlab::CLI.start(args) }
      end

      it "should show user data with excluded fields" do
        expect(@output).to_not include('John Smith')
        expect(@output).to include('bio')
        expect(@output).to include('created_at')
      end
    end

    context "when command with required fields" do
      before do
        stub_get("/user", "user")
        args = ['user', '--only=id,email,name']
        @output = capture_output { Gitlab::CLI.start(args) }
      end

      it "should show user data with required fields" do
        expect(@output).to include('id')
        expect(@output).to include('name')
        expect(@output).to include('email')
        expect(@output).to include('John Smith')
        expect(@output).to_not include('bio')
        expect(@output).to_not include('created_at')
      end
    end
  end
end
