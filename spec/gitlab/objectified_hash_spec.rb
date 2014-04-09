require 'spec_helper'

describe Gitlab::ObjectifiedHash do
  before do
    @hash = {a: 1, b: 2}
    @oh = Gitlab::ObjectifiedHash.new @hash
  end

  describe "#to_hash" do
    it "should return an original hash" do
      @oh.to_hash.should == @hash
    end

    it "should have an alias #to_h" do
      @oh.respond_to?(:to_h).should be_true
    end
  end
end
