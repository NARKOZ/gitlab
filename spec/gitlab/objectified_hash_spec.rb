require 'spec_helper'

describe Gitlab::ObjectifiedHash do
  data = {
    'animal'      => 'dog',
    'key'         => 'lock',
    'emptiness'   => nil,
    'object_hash' => { 'color' => 'red' },
    'array'       => [
      { 'id' => 'one' },
      { 'id' => 'two' }
    ]
  }

  subject(:ohash) { described_class.new data }

  it 'handles the method reader for key' do
    ohash.key.should eq('lock')
  end

  it 'coerces hashes' do
    ohash.object_hash.should be_kind_of Gitlab::ObjectifiedHash
  end

  it 'arrays of hashes are converted' do
    ohash.array.each { |h| h.should be_kind_of Gitlab::ObjectifiedHash }
  end

  it 'returns NoMethodError when a non-key is accessed' do
    expect { ohash.not_a_key }
      .to raise_error NoMethodError
  end

  data.each_pair do |data_key, data_value|
    data_key_sym = data_key.to_sym

    describe "[#{data_key.inspect}] access" do
      it "returns #{data_value.inspect}" do
        ohash[data_key].should eq(data_value)
      end
    end

    describe "[#{data_key_sym.inspect}] access" do
      it "returns #{data_value.inspect}" do
        ohash[data_key_sym].should eq(data_value)
      end
    end

    describe ".#{data_key} access" do
      it "returns #{data_value.inspect}" do
        ohash.send(data_key_sym).should eq(data_value)
      end
    end

    # .emptiness? returns false (it is nil)
    # .key? is a required part of the Hash specification.
    unless ['key', 'emptiness'].include? data_key
      describe ".#{data_key}? query" do
        it 'returns true' do
          ohash.send("#{data_key}?".to_sym).should be_true
        end
      end
    end
  end

  describe '._convert_value' do
    subject { described_class.new Hash.new }
    # Helper method
    def convert_value(value)
      subject._convert_value(value)
    end

    it 'passes ObjectifiedHashes' do
      convert_value(ohash).should eq(ohash)
    end

    it 'converts Hashes' do
      convert_value(data).should eq(ohash)
    end

    it 'converts Arrays' do
      convert_value([{ 'key' => 'value' }]).first.should be_kind_of described_class
    end
  end
end
