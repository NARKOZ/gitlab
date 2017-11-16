require 'spec_helper'

describe Gitlab::Client do
  describe ".licenses" do
    before do
      stub_get("/templates/licenses", "licenses")
      @licenses = Gitlab.licenses
    end

    it "gets the correct resource" do
      expect(a_get("/templates/licenses")).to have_been_made
    end

    it "returns a paginated response of project's licenses" do
      expect(@licenses).to be_a Gitlab::PaginatedResponse
    end
  end

  describe ".license" do
    before do
      stub_get("/templates/licenses/mit", "license")
      @license = Gitlab.license('mit')
    end

    it "gets the correct resource" do
      expect(a_get("/templates/licenses/mit")).to have_been_made
    end

    it "returns a single license" do
      expect(@license).to be_a Gitlab::ObjectifiedHash
    end

    it "returns information about an license" do
      expect(@license.key).to eq('mit')
      expect(@license.name).to eq("MIT License")
    end
  end
end
