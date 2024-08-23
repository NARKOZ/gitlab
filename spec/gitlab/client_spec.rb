# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  subject(:client) { described_class.new(options) }

  describe '#inspect' do
    subject { client.inspect }

    context 'without private token' do
      let(:options) { { private_token: nil } }

      it { is_expected.not_to include('@private_token=') }
    end

    context 'with a some lengthy private token' do
      let(:options) { { private_token: 'some token' } }

      it { is_expected.to include('@private_token="******oken"') }
    end

    context 'with a known private token' do
      let(:options) { { private_token: 'endpoint' } }

      it { is_expected.to include('@private_token="****oint"') }
      it { is_expected.to include('@endpoint=') }
    end

    context 'with empty private token' do
      let(:options) { { private_token: '' } }

      it { is_expected.to include('@private_token="****"') }
    end

    context 'with short private token' do
      let(:options) { { private_token: 'abcd' } }

      it { is_expected.to include('@private_token="****"') }
    end
  end
end
