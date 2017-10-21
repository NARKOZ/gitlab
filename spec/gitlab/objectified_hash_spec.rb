require 'spec_helper'

describe Gitlab::ObjectifiedHash do
  before do
    @hash = { a: 1, b: 2, 'string' => 'string', symbol: :symbol }
    @oh = Gitlab::ObjectifiedHash.new @hash
  end

  it "objectifies a hash" do
    expect(@oh.a).to eq(@hash[:a])
    expect(@oh.b).to eq(@hash[:b])
  end

  describe "#to_hash" do
    it "returns an original hash" do
      expect(@oh.to_hash).to eq(@hash)
    end

    it "has an alias #to_h" do
      expect(@oh.respond_to?(:to_h)).to be_truthy
    end
  end

  describe "#inspect" do
    it "returns a formatted string" do
      pretty_string = "#<#{@oh.class.name}:#{@oh.object_id} {hash: #{@hash}}"
      expect(@oh.inspect).to eq(pretty_string)
    end
  end

  describe "#respond_to" do
    it "returns true for methods this object responds to through method_missing as sym" do
      expect(@oh.respond_to?(:a)).to be_truthy
    end

    it "returns true for methods this object responds to through method_missing as string" do
      expect(@oh.respond_to?('string')).to be_truthy
    end

    it "does not care if you use a string or symbol to reference a method" do
      expect(@oh.respond_to?(:string)).to be_truthy
    end

    it "does not care if you use a string or symbol to reference a method" do
      expect(@oh.respond_to?('symbol')).to be_truthy
    end
  end
end
