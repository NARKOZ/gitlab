require 'spec_helper'

describe Gitlab::Client do
  describe ".groups" do
    before do
      stub_get("/groups", "groups")
      stub_get("/groups/3", "group")
      @group = Gitlab.group(3)
      @groups = Gitlab.groups
    end

    it "should get the correct resource" do
      a_get("/groups").should have_been_made
      a_get("/groups/3").should have_been_made
    end

    it "should return an array of Groups" do
      @groups.should be_an Array
      @groups.first.path.should == "threegroup"
    end
  end

  describe ".create_group" do
    before do
      stub_post("/groups", "group_create")
      @group = Gitlab.create_group('GitLab-Group', 'gitlab-path')
    end

    it "should get the correct resource" do
      a_post("/groups").
          with(:body => {:path => 'gitlab-path', :name => 'GitLab-Group'}).should have_been_made
    end

    it "should return information about a created group" do
      @group.name.should == "Gitlab-Group"
      @group.path.should == "gitlab-group"
    end
  end



  describe ".transfer_project_to_group" do
    before do
      stub_post("/projects", "project")
      @project = Gitlab.create_project('Gitlab')
      stub_post("/groups", "group_create")
      @group = Gitlab.create_group('GitLab-Group', 'gitlab-path')

      stub_post("/groups/#{@group.id}/projects/#{@project.id}", "group_create")
      @group_transfer = Gitlab.transfer_project_to_group(@group.id,@project.id)
    end

    it "should post to the correct resource" do
      a_post("/groups/#{@group.id}/projects/#{@project.id}").with(:body => {:id => @group.id.to_s, :project_id => @project.id.to_s}).should have_been_made
    end

    it "should return information about the group" do
      @group_transfer.name.should == @group.name
      @group_transfer.path.should == @group.path
      @group_transfer.id.should == @group.id
    end
  end

end
