require 'spec_helper'

describe Gitlab::Client do
  describe ".snippets" do
    before do
      stub_get("/projects/3/snippets", "snippets")
      @snippets = Gitlab.snippets(3)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/snippets")).to have_been_made
    end

    it "returns a paginated response of project's snippets" do
      expect(@snippets).to be_a Gitlab::PaginatedResponse
      expect(@snippets.first.file_name).to eq("mailer_test.rb")
    end
  end

  describe ".snippet" do
    before do
      stub_get("/projects/3/snippets/1", "snippet")
      @snippet = Gitlab.snippet(3, 1)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/snippets/1")).to have_been_made
    end

    it "returns information about a snippet" do
      expect(@snippet.file_name).to eq("mailer_test.rb")
      expect(@snippet.author.name).to eq("John Smith")
    end
  end

  describe ".create_snippet" do
    before do
      stub_post("/projects/3/snippets", "snippet")
      @snippet = Gitlab.create_snippet(3, title: 'API', file_name: 'api.rb', code: 'code')
    end

    it "gets the correct resource" do
      body = { title: 'API', file_name: 'api.rb', code: 'code' }
      expect(a_post("/projects/3/snippets").with(body: body)).to have_been_made
    end

    it "returns information about a new snippet" do
      expect(@snippet.file_name).to eq("mailer_test.rb")
      expect(@snippet.author.name).to eq("John Smith")
    end
  end

  describe ".edit_snippet" do
    before do
      stub_put("/projects/3/snippets/1", "snippet")
      @snippet = Gitlab.edit_snippet(3, 1, file_name: 'mailer_test.rb')
    end

    it "gets the correct resource" do
      expect(a_put("/projects/3/snippets/1").
        with(body: { file_name: 'mailer_test.rb' })).to have_been_made
    end

    it "returns information about an edited snippet" do
      expect(@snippet.file_name).to eq("mailer_test.rb")
      expect(@snippet.author.name).to eq("John Smith")
    end
  end

  describe ".delete_snippet" do
    before do
      stub_delete("/projects/3/snippets/1", "snippet")
      @snippet = Gitlab.delete_snippet(3, 1)
    end

    it "gets the correct resource" do
      expect(a_delete("/projects/3/snippets/1")).to have_been_made
    end

    it "returns information about a deleted snippet" do
      expect(@snippet.file_name).to eq("mailer_test.rb")
      expect(@snippet.author.name).to eq("John Smith")
    end
  end

  describe ".snippet_content" do
    before do
      stub_get("/projects/3/snippets/1/raw", "snippet_content")
      @snippet_content = Gitlab.snippet_content(3, 1)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/snippets/1/raw")).to have_been_made
    end

    it "returns raw content of a snippet" do
      expect(@snippet_content).to eq("#!/usr/bin/env ruby\n\nputs \"Cool snippet!\"\n")
    end
  end
end
