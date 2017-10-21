require 'spec_helper'

describe Gitlab::Client do
  it { is_expected.to respond_to :system_hooks }
  it { is_expected.to respond_to :add_system_hook }
  it { is_expected.to respond_to :system_hook }
  it { is_expected.to respond_to :delete_system_hook }

  describe ".hooks" do
    before do
      stub_get("/hooks", "system_hooks")
      @hooks = Gitlab.hooks
    end

    it "gets the correct resource" do
      expect(a_get("/hooks")).to have_been_made
    end

    it "returns a paginated response of system hooks" do
      expect(@hooks).to be_a Gitlab::PaginatedResponse
      expect(@hooks.first.url).to eq("http://example.com/hook")
    end
  end

  describe ".add_hook" do
    before do
      stub_post("/hooks", "system_hook")
      @hook = Gitlab.add_hook("http://example.com/hook", token: 'secret-token')
    end

    it "gets the correct resource" do
      expect(a_post("/hooks").with(body: hash_including(token: 'secret-token'))).to have_been_made
    end

    it "returns information about a added system hook" do
      expect(@hook.url).to eq("http://example.com/hook")
    end
  end

  describe ".hook" do
    before do
      stub_get("/hooks/3", "system_hook")
      @hook = Gitlab.hook(3)
    end

    it "gets the correct resource" do
      expect(a_get("/hooks/3")).to have_been_made
    end

    it "returns information about a added system hook" do
      expect(@hook.url).to eq("http://example.com/hook")
    end
  end

  describe ".delete_hook" do
    before do
      stub_delete("/hooks/3", "system_hook")
      @hook = Gitlab.delete_hook(3)
    end

    it "gets the correct resource" do
      expect(a_delete("/hooks/3")).to have_been_made
    end

    it "returns information about a deleted system hook" do
      expect(@hook.url).to eq("http://example.com/hook")
    end
  end
end
