require 'spec_helper'

describe Gitlab::Client do
  describe ".users" do
    before do
      stub_get("/users", "users")
      @users = Gitlab.users
    end

    it "should get the correct resource" do
      a_get("/users").should have_been_made
    end

    it "should return an array of users" do
      @users.should be_an Array
      @users.first.email.should == "john@example.com"
    end
  end

  describe ".user" do
    context "with user ID passed" do
      before do
        stub_get("/users/2", "single_user")
        @user = Gitlab.user(2)
      end

      it "should get the correct resource" do
        a_get("/users/2").should have_been_made
      end

      it "should return information about a user" do
        @user.email.should == "jack@example.com"
      end
    end

    context "without user ID passed" do
      before do
        stub_get("/user", "user")
        @user = Gitlab.user
      end

      it "should get the correct resource" do
        a_get("/user").should have_been_made
      end

      it "should return information about a current user" do
        @user.email.should == "john@example.com"
      end
    end
  end

  describe ".session" do
    before do
      stub_post("/session", "session")
      @session = Gitlab.session("email", "pass")
    end

    it "should get the correct resource" do
      a_post("/session").should have_been_made
    end

    it "should return information about a session" do
      @session.email.should == "john@example.com"
      @session.private_token.should == "qEsq1pt6HJPaNciie3MG"
    end
  end

  describe ".ssh_keys" do
    before do
      stub_get("/user/keys", "keys")
      @keys = Gitlab.ssh_keys
    end

    it "should get the correct resource" do
      a_get("/user/keys").should have_been_made
    end

    it "should return an array of SSH keys" do
      @keys.should be_an Array
      @keys.first.title.should == "narkoz@helium"
    end
  end

  describe ".ssh_key" do
    before do
      stub_get("/user/keys/1", "key")
      @key = Gitlab.ssh_key(1)
    end

    it "should get the correct resource" do
      a_get("/user/keys/1").should have_been_made
    end

    it "should return information about an SSH key" do
      @key.title.should == "narkoz@helium"
    end
  end

  describe ".create_ssh_key" do
    before do
      stub_post("/user/keys", "key")
      @key = Gitlab.create_ssh_key('title', 'body')
    end

    it "should get the correct resource" do
      body = {:title => 'title', :key => 'body'}
      a_post("/user/keys").with(:body => body).should have_been_made
    end

    it "should return information about a created SSH key" do
      @key.title.should == "narkoz@helium"
    end
  end

  describe ".delete_ssh_key" do
    before do
      stub_delete("/user/keys/1", "key")
      @key = Gitlab.delete_ssh_key(1)
    end

    it "should get the correct resource" do
      a_delete("/user/keys/1").should have_been_made
    end

    it "should return information about a deleted SSH key" do
      @key.title.should == "narkoz@helium"
    end
  end
end
