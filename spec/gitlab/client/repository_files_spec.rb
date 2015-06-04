require "spec_helper"

describe Gitlab::Client do
  describe ".get_file" do
    before do
      stub_get("/projects/3/repository/files?file_path=README.md&ref=master", "get_repository_file")
      @file = Gitlab.get_file(3, 'README.md', 'master')
    end

    it "should create the correct resource" do
      expect(a_get("/projects/3/repository/files?file_path=README.md&ref=master")).to have_been_made
    end

    it "should return the base64 encoded file" do
      expect(@file.file_path).to eq "README.md"
      expect(@file.ref).to eq "master"
      expect(@file.content).to eq "VGhpcyBpcyBhICpSRUFETUUqIQ==\n"
    end
  end

  describe ".create_file" do
    let!(:request_stub) { stub_post("/projects/3/repository/files", "repository_file") }
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
    let!(:request_stub) { stub_put("/projects/3/repository/files", "repository_file") }
    let!(:file) { Gitlab.edit_file(3, "path", "branch", "content", "commit message") }

    it "should create the correct resource" do
      expect(request_stub).to have_been_made
    end

    it "should return information about the new file" do
      expect(file.file_path).to eq "path"
      expect(file.branch_name).to eq "branch"
    end
  end

  describe ".remove_file" do
    let!(:request_stub) { stub_delete("/projects/3/repository/files", "repository_file") }
    let!(:file) { Gitlab.remove_file(3, "path", "branch", "commit message") }

    it "should create the correct resource" do
      expect(request_stub).to have_been_made
    end

    it "should return information about the new file" do
      expect(file.file_path).to eq "path"
      expect(file.branch_name).to eq "branch"
    end
  end
end
