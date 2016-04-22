require 'spec_helper'

describe Gitlab::Client do
  describe ".triggers" do
    before do
      stub_get("/projects/3/triggers", "triggers")
      @triggers = Gitlab.triggers(3)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/triggers")).to have_been_made
    end

    it "should return an array of project's triggers" do
      expect(@triggers).to be_a Gitlab::PaginatedResponse
      expect(@triggers.first.token).to eq("fbdb730c2fbdb095a0862dbd8ab88b")
    end
  end

  describe ".trigger" do
    before do
      stub_get("/projects/3/triggers/7b9148c158980bbd9bcea92c17522d", "trigger")
      @trigger = Gitlab.trigger(3, "7b9148c158980bbd9bcea92c17522d")
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/triggers/7b9148c158980bbd9bcea92c17522d")).to have_been_made
    end

    it "should return information about a trigger" do
      expect(@trigger.created_at).to eq("2015-12-23T16:25:56.760Z")
      expect(@trigger.token).to eq("7b9148c158980bbd9bcea92c17522d")
    end
  end

  describe ".create_trigger" do
    before do
      stub_post("/projects/3/triggers", "trigger")
      @trigger = Gitlab.create_trigger(3)
    end

    it "should get the correct resource" do
      expect(a_post("/projects/3/triggers")).to have_been_made
    end

    it "should return information about a new trigger" do
      expect(@trigger.created_at).to eq("2015-12-23T16:25:56.760Z")
      expect(@trigger.token).to eq("7b9148c158980bbd9bcea92c17522d")
    end
  end

  describe ".remove_trigger" do
    before do
      stub_delete("/projects/3/triggers/7b9148c158980bbd9bcea92c17522d", "trigger")
      @trigger = Gitlab.remove_trigger(3, "7b9148c158980bbd9bcea92c17522d")
    end

    it "should get the correct resource" do
      expect(a_delete("/projects/3/triggers/7b9148c158980bbd9bcea92c17522d")).to have_been_made
    end

    it "should return information about a deleted trigger" do
      expect(@trigger.created_at).to eq("2015-12-23T16:25:56.760Z")
      expect(@trigger.token).to eq("7b9148c158980bbd9bcea92c17522d")
    end
  end
end
