# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Help do
  describe '.ri_cmd' do
    context 'when ri command found' do
      it 'returns the path to RI' do
        allow(described_class).to receive(:`).with(/which ri/).and_return('/usr/bin/ri')
        expect(described_class.ri_cmd).to eq('/usr/bin/ri')
      end
    end

    context 'when ri command NOT found' do
      it 'raises RuntimeError' do
        allow(described_class).to receive(:`).with(/which ri/).and_return('')
        expect { described_class.ri_cmd }.to raise_error RuntimeError
      end
    end
  end

  describe '.change_help_output!' do
    before do
      @cmd = 'create_branch'
      @help_output = "Gitlab.#{@cmd}(4, 'new-branch', 'master')"
      @help_output_with_options = 'Gitlab.groups({ per_page: 3 })'
    end

    it 'returns a String of modified output' do
      described_class.change_help_output! @cmd, @help_output
      expect(@help_output).to eq("Gitlab.create_branch(4, 'new-branch', 'master')")
    end

    it 'formats options hash and return a String of modified output' do
      described_class.change_help_output! 'groups', @help_output_with_options
      expect(@help_output_with_options).to eq('Gitlab.groups({ per_page: 3 })')
    end
  end

  describe '.namespace' do
    before do
      @cmd = 'create_tag'
      @namespace = described_class.namespace @cmd
    end

    it 'returns the full namespace for a command' do
      expect(@namespace).to be_a String
      expect(@namespace).to eq("Gitlab::Client::Tags.#{@cmd}")
    end
  end
end
