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

  describe '.http_proxy' do
    it 'delegates the method to Gitlab::Request' do
      described_class.endpoint = 'https://api.example.com'
      request = class_spy(Gitlab::Request).as_stubbed_const

      described_class.http_proxy('proxy.example.net', 1987, 'user', 'pass')
      expect(request).to have_received(:http_proxy).with('proxy.example.net', 1987, 'user', 'pass')
    end
  end
end
