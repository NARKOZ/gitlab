require 'spec_helper'

describe Gitlab::Client do
  describe ".snippets" do
    before do
      stub_get("/projects/3/snippets", "snippets")
      @snippets = Gitlab.snippets(3)
    end

    it "should get the correct resource" do
      a_get("/projects/3/snippets").should have_been_made
    end

    it "should return an array of project's snippets" do
      @snippets.should be_an Array
      @snippets.first.file_name.should == "mailer_test.rb"
    end
  end

  describe ".snippet" do
    before do
      stub_get("/projects/3/snippets/1", "snippet")
      @snippet = Gitlab.snippet(3, 1)
    end

    it "should get the correct resource" do
      a_get("/projects/3/snippets/1").should have_been_made
    end

    it "should return information about a snippet" do
      @snippet.file_name.should == "mailer_test.rb"
      @snippet.author.name.should == "John Smith"
    end
  end

  describe ".create_snippet" do
    before do
      stub_post("/projects/3/snippets", "snippet")
      @snippet = Gitlab.create_snippet(3, {:title => 'API', :file_name => 'api.rb', :code => 'code'})
    end

    it "should get the correct resource" do
      body = {:title => 'API', :file_name => 'api.rb', :code => 'code'}
      a_post("/projects/3/snippets").with(:body => body).should have_been_made
    end

    it "should return information about a new snippet" do
      @snippet.file_name.should == "mailer_test.rb"
      @snippet.author.name.should == "John Smith"
    end
  end

  describe ".edit_snippet" do
    before do
      stub_put("/projects/3/snippets/1", "snippet")
      @snippet = Gitlab.edit_snippet(3, 1, :file_name => 'mailer_test.rb')
    end

    it "should get the correct resource" do
      a_put("/projects/3/snippets/1").
        with(:body => {:file_name => 'mailer_test.rb'}).should have_been_made
    end

    it "should return information about an edited snippet" do
      @snippet.file_name.should == "mailer_test.rb"
      @snippet.author.name.should == "John Smith"
    end
  end

  describe ".delete_snippet" do
    before do
      stub_delete("/projects/3/snippets/1", "snippet")
      @snippet = Gitlab.delete_snippet(3, 1)
    end

    it "should get the correct resource" do
      a_delete("/projects/3/snippets/1").should have_been_made
    end

    it "should return information about a deleted snippet" do
      @snippet.file_name.should == "mailer_test.rb"
      @snippet.author.name.should == "John Smith"
    end
  end
end
