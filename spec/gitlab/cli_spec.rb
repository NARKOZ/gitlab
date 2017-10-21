require 'spec_helper'
require 'json'

describe Gitlab::CLI do
  describe ".run" do
    context "when command is version" do
      it "shows gem version" do
        output = capture_output { Gitlab::CLI.run('-v') }
        expect(output).to eq("Gitlab Ruby Gem #{Gitlab::VERSION}\n")
      end
    end

    context "when command is info" do
      it "shows environment info" do
        output = capture_output { Gitlab::CLI.run('info') }
        expect(output).to include("Gitlab endpoint is")
        expect(output).to include("Gitlab private token is")
        expect(output).to include("Ruby Version is")
        expect(output).to include("Gitlab Ruby Gem")
      end
    end

    context "when command is help" do
      it "shows available actions" do
        output = capture_output { Gitlab::CLI.run('help') }
        expect(output).to include('Help Topics')
        expect(output).to include('MergeRequests')
      end
    end

    context "when command is user" do
      before do
        stub_get("/user", "user")
        @output = capture_output { Gitlab::CLI.run('user') }
      end

      it "shows executed command" do
        expect(@output).to include('Gitlab.user')
      end

      it "shows user data" do
        expect(@output).to include('name')
        expect(@output).to include('John Smith')
      end
    end

    context "when command is users" do
      before do
        stub_get("/users", "users")
        @output = capture_output { Gitlab::CLI.run('users') }
      end

      it "shows executed command" do
        expect(@output).to include('Gitlab.users')
      end

      it "shows users data" do
        expect(@output).to include('name')
        expect(@output).to include('John Smith')
        expect(@output).to include('Jack Smith')
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

      it "shows user data with excluded fields" do
        expect(@output).to_not include('John Smith')
        expect(@output).to include('bio')
        expect(@output).to include('created_at')
      end
    end

    context "when command with json output" do
      before do
        stub_get("/user", "user")
        args = ['user', '--json']
        @output = capture_output { Gitlab::CLI.start(args) }
      end

      it "renders output as json" do
        expect(JSON.parse(@output)['result']).to eq(JSON.parse(File.read(File.dirname(__FILE__) + '/../fixtures/user.json')))
        expect(JSON.parse(@output)['cmd']).to eq('Gitlab.user')
      end
    end

    context "when command with required fields" do
      before do
        stub_get("/user", "user")
        args = ['user', '--only=id,email,name']
        @output = capture_output { Gitlab::CLI.start(args) }
      end

      it "shows user data with required fields" do
        expect(@output).to include('id')
        expect(@output).to include('name')
        expect(@output).to include('email')
        expect(@output).to include('John Smith')
        expect(@output).to_not include('bio')
        expect(@output).to_not include('created_at')
      end
    end

    context "fetch project with namespace/repo" do
      it "encodes delimiter" do
        stub_get("/projects/gitlab-org%2Fgitlab-ce", "project")
        args = ['project', 'gitlab-org/gitlab-ce']
        @output = capture_output { Gitlab::CLI.start(args) }
        expect(@output).to include('id')
      end
    end
  end
end
