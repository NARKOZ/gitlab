require 'spec_helper'

describe Gitlab::Client do
  it { should respond_to :system_hooks }
  it { should respond_to :add_system_hook }
  it { should respond_to :system_hook }
  it { should respond_to :delete_system_hook }

  describe ".hooks" do
    before do
      stub_get("/hooks", "system_hooks")
      @hooks = Gitlab.hooks
    end

    it "should get the correct resource" do
      expect(a_get("/hooks")).to have_been_made
    end

    it "should return an array of system hooks" do
      expect(@hooks).to be_an Array
      expect(@hooks.first.url).to eq("http://example.com/hook")
    end
  end

  describe ".add_hook" do
    before do
      stub_post("/hooks", "system_hook")
      @hook = Gitlab.add_hook("http://example.com/hook")
    end

    it "should get the correct resource" do
      expect(a_post("/hooks")).to have_been_made
    end

    it "should return information about a added system hook" do
      expect(@hook.url).to eq("http://example.com/hook")
    end
  end

  describe ".hook" do
    before do
      stub_get("/hooks/3", "system_hook_test")
      @hook = Gitlab.hook(3)
    end
    it "should get the correct resource" do
      expect(a_get("/hooks/3")).to have_been_made
    end

    it "should return information about a added system hook" do
      expect(@hook.event_name).to eq("project_create")
      expect(@hook.project_id).to eq(1)
    end
  end

  describe ".delete_hook" do
    before do
      stub_delete("/hooks/3", "system_hook")
      @hook = Gitlab.delete_hook(3)
    end

    it "should get the correct resource" do
      expect(a_delete("/hooks/3")).to have_been_made
    end

    it "should return information about a deleted system hook" do
      expect(@hook.url).to eq("http://example.com/hook")
    end
  end
end
