# frozen_string_literal: true

require 'spec_helper'
require 'json'

describe Gitlab::CLI do
  describe '.run' do
    context 'when command is version' do
      it 'shows gem version' do
        output = capture_output { described_class.run('-v') }
        expect(output).to eq("Gitlab Ruby Gem #{Gitlab::VERSION}\n")
      end
    end

    context 'when command is info' do
      it 'shows environment info' do
        output = capture_output { described_class.run('info') }
        expect(output).to include('Gitlab endpoint is')
        expect(output).to include('Gitlab private token is')
        expect(output).to include('Ruby Version is')
        expect(output).to include('Gitlab Ruby Gem')
      end
    end

    context 'when command is help' do
      it 'shows available actions' do
        output = capture_output { described_class.run('help') }
        expect(output).to include('Help Topics')
        expect(output).to include('MergeRequests')
      end
    end

    context 'when command is user' do
      before do
        stub_get('/user', 'user')
        @output = capture_output { described_class.run('user') }
      end

      it 'shows executed command' do
        expect(@output).to include('Gitlab.user')
      end

      it 'shows user data' do
        expect(@output).to include('name')
        expect(@output).to include('John Smith')
      end
    end

    context 'when command is users' do
      before do
        stub_get('/users', 'users')
        @output = capture_output { described_class.run('users') }
      end

      it 'shows executed command' do
        expect(@output).to include('Gitlab.users')
      end

      it 'shows users data' do
        expect(@output).to include('name')
        expect(@output).to include('John Smith')
        expect(@output).to include('Jack Smith')
      end
    end

    context 'when command is create_label' do
      before do
        stub_post('/projects/Project/labels', 'label')
        args = ['Project', 'Backlog', '#DD10AA']
        @output = capture_output { described_class.run('create_label', args) }
      end

      it 'shows executed command' do
        expect(@output).to include('Gitlab.create_label Project, Backlog, #DD10AA')
      end
    end
  end

  describe '.start' do
    context 'when command with excluded fields' do
      before do
        stub_get('/user', 'user')
        args = ['user', '--except=id,email,name']
        @output = capture_output { described_class.start(args) }
      end

      it 'shows user data with excluded fields' do
        expect(@output).not_to include('John Smith')
        expect(@output).to include('bio')
        expect(@output).to include('created_at')
      end
    end

    context 'when command with json output' do
      before do
        stub_get('/user', 'user')
        args = ['user', '--json']
        @output = capture_output { described_class.start(args) }
      end

      it 'renders output as json' do
        expect(JSON.parse(@output)['result']).to eq(JSON.parse(File.read(File.dirname(__FILE__) + '/../fixtures/user.json')))
        expect(JSON.parse(@output)['cmd']).to eq('Gitlab.user')
      end
    end

    context 'when command with required fields' do
      before do
        stub_get('/user', 'user')
        args = ['user', '--only=id,email,name']
        @output = capture_output { described_class.start(args) }
      end

      it 'shows user data with required fields' do
        expect(@output).to include('id')
        expect(@output).to include('name')
        expect(@output).to include('email')
        expect(@output).to include('John Smith')
        expect(@output).not_to include('bio')
        expect(@output).not_to include('created_at')
      end
    end

    context 'fetch project with namespace/repo' do
      it 'encodes delimiter' do
        stub_get('/projects/gitlab-org%2Fgitlab-ce', 'project')
        args = ['project', 'gitlab-org/gitlab-ce']
        @output = capture_output { described_class.start(args) }
        expect(@output).to include('id')
      end
    end
  end
end
