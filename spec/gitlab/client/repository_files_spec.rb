require "spec_helper"

describe Gitlab::Client do
  describe ".file_contents" do
    before do
      stub_get("/projects/3/repository/files/Gemfile/raw?ref=master", "raw_file")
      @file_contents = Gitlab.file_contents(3, "Gemfile")
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/repository/files/Gemfile/raw?ref=master")).to have_been_made
    end

    it "returns file contents" do
      expect(@file_contents).to eq("source 'https://rubygems.org'\ngem 'rails', '4.1.2'\n")
    end
  end

  describe ".get_file" do
    before do
      stub_get("/projects/3/repository/files/README%2Emd?ref=master", "get_repository_file")
      @file = Gitlab.get_file(3, 'README.md', 'master')
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/repository/files/README%2Emd?ref=master")).to have_been_made
    end

    it "returns the base64 encoded file" do
      expect(@file.file_path).to eq "README.md"
      expect(@file.ref).to eq "master"
      expect(@file.content).to eq "VGhpcyBpcyBhICpSRUFETUUqIQ==\n"
    end
  end

  describe ".create_file" do
    let(:api_path) { "/projects/3/repository/files/path" }
    let!(:request_stub) { stub_post(api_path, "repository_file") }
    let!(:file) { Gitlab.create_file(3, "path", "branch", "content", "commit message", author_name: "joe") }

    it "creates the correct resource" do
      expected_parameters = {
        author_name: "joe",
        branch: "branch",
        commit_message: "commit message"
      }
      expect(a_post(api_path).with(body: hash_including(expected_parameters))).to have_been_made
    end

    it "returns information about the new file" do
      expect(file.file_path).to eq "path"
      expect(file.branch_name).to eq "branch"
    end
  end

  describe ".edit_file" do
    let(:api_path) { "/projects/3/repository/files/path" }
    let!(:request_stub) { stub_put(api_path, "repository_file") }
    let!(:file) { Gitlab.edit_file(3, "path", "branch", "content", "commit message", author_name: "joe") }

    it "updates the correct resource" do
      expected_parameters = {
        author_name: "joe",
        branch: "branch",
        commit_message: "commit message"
      }
      expect(a_put(api_path).with(body: hash_including(expected_parameters))).to have_been_made
    end

    it "returns information about the new file" do
      expect(file.file_path).to eq "path"
      expect(file.branch_name).to eq "branch"
    end
  end

  describe ".remove_file" do
    let(:api_path) { "/projects/3/repository/files/path" }
    let!(:request_stub) { stub_delete(api_path, "repository_file") }
    let!(:file) { Gitlab.remove_file(3, "path", "branch", "commit message", author_name: "joe") }

    it "updates the correct resource" do
      expected_parameters = {
        author_name: "joe",
        branch: "branch",
        commit_message: "commit message"
      }
      expect(a_delete(api_path).with(body: hash_including(expected_parameters))).to have_been_made
    end

    it "returns information about the new file" do
      expect(file.file_path).to eq "path"
      expect(file.branch_name).to eq "branch"
    end
  end
end
