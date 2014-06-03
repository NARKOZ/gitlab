require 'spec_helper'

describe Gitlab::ObjectifiedHash do
  before do
    @hash = {a: 1, b: 2}
    @oh = Gitlab::ObjectifiedHash.new @hash
  end

  it "should objectify hash" do
    expect(@oh.a).to eq(@hash[:a])
    expect(@oh.b).to eq(@hash[:b])
  end

  describe "#to_hash" do
    it "should return an original hash" do
      expect(@oh.to_hash).to eq(@hash)
    end

    it "should have an alias #to_h" do
      expect(@oh.respond_to?(:to_h)).to be_truthy
    end
  end
end
