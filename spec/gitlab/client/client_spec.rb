# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '#inspect' do
    it 'masks tokens on inspect' do
      client = described_class.new(private_token: 'ui3gIYf4MMzTx-Oh5cEBx')
      inspected = client.inspect
      expect(inspected).to include('****************cEBx')
    end
  end
end
