require 'spec_helper'

describe Gitlab::Client do
  it { should respond_to :namespaces }

  describe ".namespaces" do
    before do
      stub_get("/namespaces", "namespaces")
      @namespaces = Gitlab.namespaces
    end

    it "should get the correct resource" do
      expect(a_get("/namespaces")).to have_been_made
    end

    it "should return an array of namespaces" do
      expect(@namespaces).to be_an Array
      expect(@namespaces.first.path).to eq("john")
      expect(@namespaces.first.kind).to eq("user")
    end
  end
end
