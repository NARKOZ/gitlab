require 'spec_helper'

describe Gitlab::Client do
  describe ".key" do
    before do
      stub_get("/keys/1", "key")
      @key = Gitlab.key(1)
    end

    it "gets the correct resource" do
      expect(a_get("/keys/1")).to have_been_made
    end

    it "returns information about a key" do
      expect(@key.id).to eq(1)
      expect(@key.title).to eq("narkoz@helium")
    end
  end
end
