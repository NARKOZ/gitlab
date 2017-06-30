require "spec_helper"

describe Gitlab::Client do
  describe ".file_contents" do
    before do
      stub_get("/projects/3/repository/files/Gemfile/raw?ref=master", "raw_file")
      @file_contents = Gitlab.file_contents(3, "Gemfile")
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/files/Gemfile/raw?ref=master")).to have_been_made
    end

    it "should return file contents" do
      expect(@file_contents).to eq("source 'https://rubygems.org'\ngem 'rails', '4.1.2'\n")
    end
  end

  describe ".get_file" do
    before do
      stub_get("/projects/3/repository/files/README%2Emd?ref=master", "get_repository_file")
      @file = Gitlab.get_file(3, 'README.md', 'master')
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/repository/files/README%2Emd?ref=master")).to have_been_made
    end

    it "should return the base64 encoded file" do
      expect(@file.file_path).to eq "README.md"
      expect(@file.ref).to eq "master"
      expect(@file.content).to eq "VGhpcyBpcyBhICpSRUFETUUqIQ==\n"
    end
  end

  describe ".create_file" do
    let!(:request_stub) { stub_post("/projects/3/repository/files/path", "repository_file") }
    let!(:file) { Gitlab.create_file(3, "path", "branch", "content", "commit message") }

    it "should create the correct resource" do
      expect(request_stub).to have_been_made
    end

    it "should return information about the new file" do
      expect(file.file_path).to eq "path"
      expect(file.branch_name).to eq "branch"
    end
  end

  describe ".edit_file" do
    let!(:request_stub) { stub_put("/projects/3/repository/files/path", "repository_file") }
    let!(:file) { Gitlab.edit_file(3, "path", "branch", "content", "commit message") }

    it "should update the correct resource" do
      expect(request_stub).to have_been_made
    end

    it "should return information about the new file" do
      expect(file.file_path).to eq "path"
      expect(file.branch_name).to eq "branch"
    end
  end

  describe ".remove_file" do
    let!(:request_stub) { stub_delete("/projects/3/repository/files/path", "repository_file") }
    let!(:file) { Gitlab.remove_file(3, "path", "branch", "commit message") }

    it "should update the correct resource" do
      expect(request_stub).to have_been_made
    end

    it "should return information about the new file" do
      expect(file.file_path).to eq "path"
      expect(file.branch_name).to eq "branch"
    end
  end
end
