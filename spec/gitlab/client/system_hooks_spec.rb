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
      a_get("/hooks").should have_been_made
    end

    it "should return an array of system hooks" do
      @hooks.should be_an Array
      @hooks.first.url.should == "http://example.com/hook"
    end
  end

  describe ".add_hook" do
    before do
      stub_post("/hooks", "system_hook")
      @hook = Gitlab.add_hook("http://example.com/hook")
    end

    it "should get the correct resource" do
      a_post("/hooks").should have_been_made
    end

    it "should return information about a added system hook" do
      @hook.url.should == "http://example.com/hook"
    end
  end

  describe ".hook" do
    before do
      stub_get("/hooks/3", "system_hook_test")
      @hook = Gitlab.hook(3)
    end
    it "should get the correct resource" do
      a_get("/hooks/3").should have_been_made
    end

    it "should return information about a added system hook" do
      @hook.event_name.should == "project_create"
      @hook.project_id.should == 1
    end
  end

  describe ".delete_hook" do
    before do
      stub_delete("/hooks/3", "system_hook")
      @hook = Gitlab.delete_hook(3)
    end

    it "should get the correct resource" do
      a_delete("/hooks/3").should have_been_made
    end

    it "should return information about a deleted system hook" do
      @hook.url.should == "http://example.com/hook"
    end
  end
end
