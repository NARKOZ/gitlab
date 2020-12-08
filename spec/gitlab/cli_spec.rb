# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::CLI do
  describe '.run' do
    context 'when command is version' do
      it 'shows gem version' do
        expect { described_class.run('-v') }.to output("Gitlab Ruby Gem #{Gitlab::VERSION}\n").to_stdout
      end
    end

    context 'when command is info' do
      it 'shows environment info' do
        command = expect { described_class.run('info') }
        command.to output(/Gitlab endpoint is/).to_stdout
        command.to output(/Gitlab private token is/).to_stdout
        command.to output(/Ruby Version is/).to_stdout
        command.to output(/Gitlab Ruby Gem/).to_stdout
      end
    end

    context 'when command is help' do
      it 'shows available actions' do
        command = expect { described_class.run('help') }
        command.to output(/Help Topics/).to_stdout
        command.to output(/MergeRequests/).to_stdout
      end
    end

    context 'when command is user' do
      before { stub_get('/user', 'user') }

      it 'shows executed command' do
        expect { described_class.run('user') }.to output(/Gitlab.user/).to_stdout
      end

      it 'shows user data' do
        command = expect { described_class.run('user') }
        command.to output(/name/).to_stdout
        command.to output(/John Smith/).to_stdout
      end
    end

    context 'when command is users' do
      before { stub_get('/users', 'users') }

      it 'shows executed command' do
        expect { described_class.run('users') }.to output(/Gitlab.users/).to_stdout
      end

      it 'shows users data' do
        command = expect { described_class.run('users') }
        command.to output(/name/).to_stdout
        command.to output(/John Smith/).to_stdout
        command.to output(/Jack Smith/).to_stdout
      end
    end

    context 'when command is create_label' do
      before { stub_post('/projects/Project/labels', 'label') }

      let(:args) { ['Project', 'Backlog', '#DD10AA'] }

      it 'shows executed command' do
        command = expect { described_class.run('create_label', args) }
        command.to output(/Gitlab.create_label Project, Backlog, #DD10AA/).to_stdout
      end
    end
  end

  describe '.start' do
    before { stub_get('/user', 'user') }

    context 'when command with excluded fields' do
      let(:args) { ['user', '--except=id,email,name'] }

      it 'shows user data with excluded fields' do
        command = expect { described_class.start(args) }
        command.not_to output(/John Smith/).to_stdout
        command.to output(/bio/).to_stdout
        command.to output(/created_at/).to_stdout
      end
    end

    context 'when command with required fields' do
      let(:args) { ['user', '--only=id,email,name'] }

      it 'shows user data with required fields' do
        command = expect { described_class.start(args) }
        command.to output(/id/).to_stdout
        command.to output(/name/).to_stdout
        command.to output(/email/).to_stdout
        command.to output(/John Smith/).to_stdout
        command.not_to output(/bio/).to_stdout
        command.not_to output(/created_at/).to_stdout
      end
    end

    context 'when command with json output' do
      let(:args) { ['user', '--json'] }

      it 'renders output as json' do
        expected = <<~OUT
          {
            "cmd": "Gitlab.user",
            "result": {
              "bio": null,
              "blocked": false,
              "created_at": "2012-09-17T09:41:56Z",
              "dark_scheme": false,
              "email": "john@example.com",
              "id": 1,
              "linkedin": "",
              "name": "John Smith",
              "skype": "",
              "theme_id": 1,
              "twitter": "john",
              "username": "john.smith"
            }
          }
        OUT
        expect { described_class.start(args) }.to output(expected).to_stdout
      end
    end

    context 'when fetching project with namespace/repo' do
      it 'encodes delimiter' do
        stub_get('/projects/gitlab-org%2Fgitlab-ce', 'project')
        args = ['project', 'gitlab-org/gitlab-ce']
        expect { described_class.start(args) }.to output(/id/).to_stdout
      end
    end
  end
end
