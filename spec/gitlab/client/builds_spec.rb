require 'spec_helper'

describe Gitlab::Client do
  describe ".builds" do
    before do
      stub_get("/projects/3/builds", "builds")
      @builds = Gitlab.builds(3)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/builds")).to have_been_made
    end

    it "should return a paginated response of project's builds" do
      expect(@builds).to be_a Gitlab::PaginatedResponse
    end
  end

end
