# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::HeaderResponse do
  subject(:resp) { described_class.new }

  let(:headers) do
    {
      'x-gitlab-blob-size' => ['42'],
      'x-gitlab-commit-id' => ['foobar'],
      'content-type' => ['application/json']
    }
  end

  describe '.empty?' do
    it 'returns false' do
      expect(resp).to be_empty
    end
  end

  describe '.to_hash' do
    it 'empty hash after init' do
      expect(resp.to_hash).to eq({})
    end
  end

  describe '.parse_headers!' do
    subject(:resp_with_h) do
      resp.parse_headers!(headers)
      resp
    end

    it 'parses headers' do
      expect(resp_with_h.to_h).to eq(
        {
          blob_size: '42',
          commit_id: 'foobar'
        }
      )
    end

    it 'handles getters' do
      expect(resp_with_h.commit_id).to eq('foobar')
    end

    it 'nonexistant header' do
      expect { resp_with_h.expires_in }.to raise_error(NoMethodError)
    end
  end
end
