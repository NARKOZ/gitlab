# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.group_badges' do
    before do
      stub_get('/groups/3/badges', 'badges')
      @badges = Gitlab.group_badges(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/badges')).to have_been_made
    end

    it 'returns a paginated response of badges' do
      expect(@badges).to be_a Gitlab::PaginatedResponse
      expect(@badges.first.link_url).to eq('http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}')
      expect(@badges.first.kind).to eq('project')
    end
  end

  describe '.group_badge' do
    before do
      stub_get('/groups/3/badges/1', 'badge')
      @badge = Gitlab.group_badge(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/badges/1')).to have_been_made
    end

    it 'returns information about a badge' do
      expect(@badge.link_url).to eq('http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}')
      expect(@badge.image_url).to eq('https://shields.io/my/badge')
    end
  end

  describe '.add_group_badge' do
    before do
      stub_post('/groups/Gitlab/badges', 'badge')
      @badge = Gitlab.add_group_badge('Gitlab', 'http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}', 'https://shields.io/my/badge')
    end

    it 'gets the correct resource' do
      expect(a_post('/groups/Gitlab/badges')).to have_been_made
    end

    it 'returns information about a badge added to project' do
      expect(@badge.link_url).to eq('http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}')
      expect(@badge.image_url).to eq('https://shields.io/my/badge')
    end
  end

  describe '.edit_group_badge' do
    before do
      stub_put('/groups/3/badges/1', 'badge')
      @badge = Gitlab.edit_group_badge(3, 1, {image_url: 'https://shields.io/your/badge'})
    end

    it 'gets the correct resource' do
      expect(a_put('/groups/3/badges/1')
          .with(body: { image_url: 'https://shields.io/your/badge' })).to have_been_made
    end

    it 'returns information about an edited badge' do
      expect(@badge.link_url).to eq('http://example.com/ci_status.svg?project=%{project_path}&ref=%{default_branch}')
    end
  end

  describe '.remove_group_badge' do
    before do
      stub_delete('/groups/Gitlab/badges/1', 'remove_badge')
      @project = Gitlab.remove_group_badge('Gitlab', 1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/groups/Gitlab/badges/1')).to have_been_made
    end
  end

  describe '.groups' do
    before do
      stub_get('/groups', 'groups')
      stub_get('/groups/3', 'group')
      @group = Gitlab.group(3)
      @groups = Gitlab.groups
    end

    it 'gets the correct resource' do
      expect(a_get('/groups')).to have_been_made
      expect(a_get('/groups/3')).to have_been_made
    end

    it 'returns a paginated response of groups' do
      expect(@groups).to be_a Gitlab::PaginatedResponse
      expect(@groups.first.path).to eq('threegroup')
    end
  end

  describe '.create_group' do
    context 'without description' do
      before do
        stub_post('/groups', 'group_create')
        @group = Gitlab.create_group('GitLab-Group', 'gitlab-path')
      end

      it 'gets the correct resource' do
        expect(a_post('/groups')
            .with(body: { path: 'gitlab-path', name: 'GitLab-Group' })).to have_been_made
      end

      it 'returns information about a created group' do
        expect(@group.name).to eq('Gitlab-Group')
        expect(@group.path).to eq('gitlab-group')
      end
    end

    context 'with description' do
      before do
        stub_post('/groups', 'group_create_with_description')
        @group = Gitlab.create_group('GitLab-Group', 'gitlab-path', description: 'gitlab group description')
      end

      it 'gets the correct resource' do
        expect(a_post('/groups')
                 .with(body: { path: 'gitlab-path', name: 'GitLab-Group',
                               description: 'gitlab group description' })).to have_been_made
      end

      it 'returns information about a created group' do
        expect(@group.name).to eq('Gitlab-Group')
        expect(@group.path).to eq('gitlab-group')
        expect(@group.description).to eq('gitlab group description')
      end
    end
  end

  describe '.delete_group' do
    before do
      stub_delete('/groups/42', 'group_delete')
      @group = Gitlab.delete_group(42)
    end

    it 'gets the correct resource' do
      expect(a_delete('/groups/42')).to have_been_made
    end

    it 'returns information about a deleted group' do
      expect(@group.name).to eq('Gitlab-Group')
      expect(@group.path).to eq('gitlab-group')
    end
  end

  describe '.transfer_project_to_group' do
    before do
      stub_post('/projects', 'project')
      @project = Gitlab.create_project('Gitlab')
      stub_post('/groups', 'group_create')
      @group = Gitlab.create_group('GitLab-Group', 'gitlab-path')

      stub_post("/groups/#{@group.id}/projects/#{@project.id}", 'group_create')
      @group_transfer = Gitlab.transfer_project_to_group(@group.id, @project.id)
    end

    it 'posts to the correct resource' do
      expect(a_post("/groups/#{@group.id}/projects/#{@project.id}").with(body: { id: @group.id.to_s, project_id: @project.id.to_s })).to have_been_made
    end

    it 'returns information about the group' do
      expect(@group_transfer.name).to eq(@group.name)
      expect(@group_transfer.path).to eq(@group.path)
      expect(@group_transfer.id).to eq(@group.id)
    end
  end

  describe '.group_members' do
    before do
      stub_get('/groups/3/members', 'group_members')
      @members = Gitlab.group_members(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/members')).to have_been_made
    end

    it "returns information about a group's members" do
      expect(@members).to be_a Gitlab::PaginatedResponse
      expect(@members.size).to eq(2)
      expect(@members[1].name).to eq('John Smith')
    end
  end

  describe '.group_member' do
    before do
      stub_get('/groups/3/members/2', 'group_member')
      @member = Gitlab.group_member(3, 2)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/members/2')).to have_been_made
    end

    it 'returns information about a group member' do
      expect(@member).to be_a Gitlab::ObjectifiedHash
      expect(@member.access_level).to eq(10)
      expect(@member.name).to eq('John Smith')
    end
  end

  describe '.add_group_member' do
    before do
      stub_post('/groups/3/members', 'group_member')
      @member = Gitlab.add_group_member(3, 1, 40)
    end

    it 'gets the correct resource' do
      expect(a_post('/groups/3/members')
        .with(body: { user_id: '1', access_level: '40' })).to have_been_made
    end

    it 'returns information about the added member' do
      expect(@member.name).to eq('John Smith')
    end
  end

  describe '.edit_group_member' do
    before do
      stub_put('/groups/3/members/1', 'group_member_edit')
      @member = Gitlab.edit_group_member(3, 1, 50)
    end

    it 'gets the correct resource' do
      expect(a_put('/groups/3/members/1')
          .with(body: { access_level: '50' })).to have_been_made
    end

    it 'returns information about the edited member' do
      expect(@member.access_level).to eq(50)
    end
  end

  describe '.remove_group_member' do
    before do
      stub_delete('/groups/3/members/1', 'group_member_delete')
      @group = Gitlab.remove_group_member(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/groups/3/members/1')).to have_been_made
    end

    it 'returns information about the group the member was removed from' do
      expect(@group.group_id).to eq(3)
    end
  end

  describe '.group_projects' do
    before do
      stub_get('/groups/4/projects', 'group_projects')
      @projects = Gitlab.group_projects(4)
    end

    it 'gets the list of projects' do
      expect(a_get('/groups/4/projects')).to have_been_made
    end

    it 'returns a list of of projects under a group' do
      expect(@projects).to be_a Gitlab::PaginatedResponse
      expect(@projects.size).to eq(1)
      expect(@projects[0].name).to eq('Diaspora Client')
    end
  end

  describe '.group_search' do
    before do
      stub_get('/groups?search=Group', 'group_search')
      @groups = Gitlab.group_search('Group')
    end

    it 'gets the correct resource' do
      expect(a_get('/groups?search=Group')).to have_been_made
    end

    it 'returns an array of groups found' do
      expect(@groups.first.id).to eq(5)
      expect(@groups.last.id).to eq(8)
    end
  end

  describe '.group_subgroups' do
    before do
      stub_get('/groups/4/subgroups', 'group_subgroups')
      @subgroups = Gitlab.group_subgroups(4)
    end

    it 'gets the list of subroups' do
      expect(a_get('/groups/4/subgroups')).to have_been_made
    end

    it 'returns an array of subgroups under a group' do
      expect(@subgroups).to be_a Gitlab::PaginatedResponse
      expect(@subgroups.size).to eq(1)
      expect(@subgroups[0].name).to eq('Foobar Group')
    end
  end

  describe '.edit_group' do
    context 'using group ID' do
      before do
        stub_put('/groups/1', 'group_edit').with(body: { description: 'An interesting group' })
        @edited_project = Gitlab.edit_group(1, description: 'An interesting group')
      end

      it 'gets the correct resource' do
        expect(a_put('/groups/1').with(body: { description: 'An interesting group' })).to have_been_made
      end

      it 'returns information about an edited group' do
        expect(@edited_project.description).to eq('An interesting group')
      end
    end
  end
end
