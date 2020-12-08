# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::ObjectifiedHash do
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
      warning = "WARNING: Please convert ObjectifiedHash object to hash before calling Hash methods on it.\n"
      expect { oh.values }.to output(warning).to_stderr
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
    it 'returns true for methods object responds to through method_missing' do
      expect(@oh).to respond_to(:a)
    end

    it 'allows to use a symbol to reference a method' do
      expect(@oh).to respond_to(:symbol)
    end

    it 'allows to use a string to reference a method' do
      expect(@oh).to respond_to('string')
    end
  end
end
