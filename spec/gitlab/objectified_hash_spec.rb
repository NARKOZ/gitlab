# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::ObjectifiedHash do
  before do
    @hash = { a: 1, b: 2, 'string' => 'string', symbol: :symbol, array: ['string', { a: 1, b: 2 }] }
    @oh = described_class.new @hash
  end

  describe 'Hash behavior' do
    let(:hash) { { foo: 'bar' } }
    let(:oh) { described_class.new(hash) }

    it 'allows to call Hash methods' do
      expect(oh['foo']).to eq('bar')
      expect(oh.merge(key: :value)).to eq('foo' => 'bar', key: :value)
    end

    it 'warns about calling Hash methods' do
      output = capture_output { oh.values }
      expect(output).to eq("WARNING: Please convert ObjectifiedHash object to hash before calling Hash methods on it.\n")
    end
  end

  it 'objectifies a hash' do
    expect(@oh.a).to eq(@hash[:a])
    expect(@oh.b).to eq(@hash[:b])
  end

  it 'objectifies a hash contained in an array' do
    expect(@oh.array[1].a).to eq(@hash[:array][1][:a])
    expect(@oh.array[1].b).to eq(@hash[:array][1][:b])
    expect(@oh.array[0]).to eq(@hash[:array][0])
  end

  it 'supports legacy addressing mode' do
    expect(@oh['a']).to eq(@hash[:a])
    expect(@oh['b']).to eq(@hash[:b])
  end

  describe '#to_hash' do
    it 'returns an original hash' do
      expect(@oh.to_hash).to eq(@hash)
    end

    it 'has an alias #to_h' do
      expect(@oh).to respond_to(:to_h)
    end
  end

  describe '#inspect' do
    it 'returns a formatted string' do
      pretty_string = "#<#{@oh.class.name}:#{@oh.object_id} {hash: #{@hash}}"
      expect(@oh.inspect).to eq(pretty_string)
    end
  end

  describe '#respond_to' do
    it 'returns true for methods this object responds to through method_missing as sym' do
      expect(@oh).to respond_to(:a)
    end

    it 'returns true for methods this object responds to through method_missing as string' do
      expect(@oh).to respond_to('string')
    end

    it 'does not care if you use a string or symbol to reference a method' do
      expect(@oh).to respond_to(:string)
    end

    it 'does not care if you use a string or symbol to reference a method' do
      expect(@oh).to respond_to('symbol')
    end
  end
end
