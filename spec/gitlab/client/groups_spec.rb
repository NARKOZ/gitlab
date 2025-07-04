# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
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

  describe '.group' do
    before do
      stub_get('/groups/3?with_projects=false', 'group')
      @group = Gitlab.group(3, with_projects: false)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3?with_projects=false')).to have_been_made
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

  describe '.all_group_members' do
    before do
      stub_get('/groups/3/members/all', 'group_members')
      @all_members = Gitlab.all_group_members(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/members/all')).to have_been_made
    end

    it "returns information about a group's members" do
      expect(@all_members).to be_a Gitlab::PaginatedResponse
      expect(@all_members.size).to eq(2)
      expect(@all_members[1].name).to eq('John Smith')
    end
  end

  describe '.group_descendants' do
    before do
      stub_get('/groups/3/descendant_groups', 'group_descendants')
      @descendants = Gitlab.group_descendants(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/descendant_groups')).to have_been_made
    end

    it "returns information about a group's descendants" do
      expect(@descendants).to be_a Gitlab::PaginatedResponse
      expect(@descendants.size).to eq(2)
      expect(@descendants[1].name).to eq('Foobar Group 2')
    end
  end

  describe '.group_billable_members' do
    before do
      stub_get('/groups/3/billable_members', 'group_billable_members')
      @members = Gitlab.group_billable_members(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/billable_members')).to have_been_made
    end

    it "returns information about a group's billable members" do
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

    context 'with member_role_id' do
      before do
        stub_post('/groups/4/members', 'group_member') # Assuming fixture 'group_member' is suitable
        @member_with_role = Gitlab.add_group_member(4, 2, 30, member_role_id: 5)
      end

      it 'gets the correct resource with member_role_id' do
        expect(a_post('/groups/4/members')
          .with(body: { user_id: '2', access_level: '30', member_role_id: '5' })).to have_been_made
      end

      it 'returns information about the added member' do
        # NOTE: The 'group_member' fixture does not include member_role_id in the response.
        # So, we can only verify the request was made correctly.
        expect(@member_with_role.name).to eq('John Smith')
      end
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

    context 'with member_role_id' do
      before do
        stub_put('/groups/4/members/2', 'group_member_edit') # Assuming fixture 'group_member_edit' is suitable
        @member_with_role = Gitlab.edit_group_member(4, 2, 20, member_role_id: 6)
      end

      it 'gets the correct resource with member_role_id' do
        expect(a_put('/groups/4/members/2')
          .with(body: { access_level: '20', member_role_id: '6' })).to have_been_made
      end

      it 'returns information about the edited member' do
        # NOTE: The 'group_member_edit' fixture does not include member_role_id in the response.
        # So, we can only verify the request was made correctly.
        expect(@member_with_role.access_level).to eq(50) # This will depend on the 'group_member_edit' fixture content
      end
    end
  end

  describe '.override_group_member' do
    before do
      stub_post('/groups/3/members/1/override', 'group_member_override')
      @member = Gitlab.override_group_member(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_post('/groups/3/members/1/override')).to have_been_made
    end

    it 'returns the override flag for the member' do
      expect(@member.override).to be(true)
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

  describe '.group_issues' do
    before do
      stub_get('/groups/3/issues', 'group_issues')
      @issues = Gitlab.group_issues(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/issues')).to have_been_made
    end

    it "returns a paginated response of project's issues" do
      expect(@issues).to be_a Gitlab::PaginatedResponse
      expect(@issues.first.project_id).to eq(4)
    end
  end

  describe '.group_merge_requests' do
    before do
      stub_get('/groups/3/merge_requests', 'group_merge_requests')
      @merge_requests = Gitlab.group_merge_requests(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/merge_requests')).to have_been_made
    end

    it "returns information about a group's merge requests" do
      expect(@merge_requests).to be_a Gitlab::PaginatedResponse
      expect(@merge_requests.first.project_id).to eq(3)
    end
  end

  describe '.sync_ldap_group' do
    before do
      stub_post('/groups/1/ldap_sync', 'group_ldap_sync')
      Gitlab.sync_ldap_group(1)
    end

    it 'gets the correct resource' do
      expect(a_post('/groups/1/ldap_sync')).to have_been_made
    end
  end

  describe '.add_ldap_group_links' do
    before do
      stub_post('/groups/1/ldap_group_links', 'group_add_ldap_links')
      @ldap_link = Gitlab.add_ldap_group_links(1, 'all', 50, 'ldap')
    end

    it 'gets the correct resource' do
      expect(a_post('/groups/1/ldap_group_links')
          .with(body: { cn: 'all', group_access: 50, provider: 'ldap' })).to have_been_made
    end

    it 'returns information about the created ldap link' do
      expect(@ldap_link.cn).to eq('all')
      expect(@ldap_link.group_access).to eq(50)
      expect(@ldap_link.provider).to eq('ldap')
    end
  end

  describe '.delete_ldap_group_links' do
    before do
      stub_delete('/groups/1/ldap_group_links/ldap/all', 'group_delete_ldap_links')
      Gitlab.delete_ldap_group_links(1, 'all', 'ldap')
    end

    it 'gets the correct resource' do
      expect(a_delete('/groups/1/ldap_group_links/ldap/all')).to have_been_made
    end
  end

  describe '.group_custom_attributes' do
    before do
      stub_get('/groups/2/custom_attributes', 'group_custom_attributes')
      @custom_attributes = Gitlab.group_custom_attributes(2)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/2/custom_attributes')).to have_been_made
    end

    it 'returns a information about a custom_attribute of group' do
      expect(@custom_attributes.first.key).to eq 'somekey'
      expect(@custom_attributes.last.value).to eq('somevalue2')
    end
  end

  describe '.group_custom_attribute' do
    before do
      stub_get('/groups/2/custom_attributes/some_new_key', 'group_custom_attribute')
      @custom_attribute = Gitlab.group_custom_attribute('some_new_key', 2)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/2/custom_attributes/some_new_key')).to have_been_made
    end

    it 'returns a information about the single custom_attribute of group' do
      expect(@custom_attribute.key).to eq 'some_new_key'
      expect(@custom_attribute.value).to eq('some_new_value')
    end
  end

  describe '.add_custom_attribute' do
    describe 'with group ID' do
      before do
        stub_put('/groups/2/custom_attributes/some_new_key', 'group_custom_attribute')
        @custom_attribute = Gitlab.add_group_custom_attribute('some_new_key', 'some_new_value', 2)
      end

      it 'gets the correct resource' do
        body = { value: 'some_new_value' }
        expect(a_put('/groups/2/custom_attributes/some_new_key').with(body: body)).to have_been_made
        expect(a_put('/groups/2/custom_attributes/some_new_key')).to have_been_made
      end

      it 'returns information about a new custom attribute' do
        expect(@custom_attribute.key).to eq 'some_new_key'
        expect(@custom_attribute.value).to eq 'some_new_value'
      end
    end
  end

  describe '.delete_custom_attribute' do
    describe 'with group ID' do
      before do
        stub_delete('/groups/2/custom_attributes/some_new_key', 'group_custom_attribute')
        @custom_attribute = Gitlab.delete_group_custom_attribute('some_new_key', 2)
      end

      it 'gets the correct resource' do
        expect(a_delete('/groups/2/custom_attributes/some_new_key')).to have_been_made
      end

      it 'returns information about a deleted custom_attribute' do
        expect(@custom_attribute).to be_truthy
      end
    end
  end

  describe '.list_group_hooks' do
    before do
      stub_get('/groups/3/hooks', 'group_hooks')
      @hooks = Gitlab.list_group_hooks(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/hooks')).to have_been_made
    end

    it 'returns a list of registered group hooks based on the group id' do
      expect(@hooks).to be_a Gitlab::PaginatedResponse
      expect(@hooks.size).to eq(1)
      expect(@hooks[0].url).to eq('http://example.com/hook')
    end
  end

  describe '.group_hook(group_id, hook_id)' do
    before do
      stub_get('/groups/3/hooks/1', 'group_hook')
      @hook = Gitlab.group_hook(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/hooks/1')).to have_been_made
    end

    it 'returns information about the requested group hook' do
      expect(@hook).to be_a Gitlab::ObjectifiedHash
      expect(@hook.url).to eq('http://example.com/hook')
    end
  end

  describe '.add_group_hook(group_id, url, options)' do
    before do
      stub_post('/groups/3/hooks', 'group_hook')
      @hook = Gitlab.add_group_hook(3, 'http://example.com', {
                                      push_events: true,
                                      push_events_branch_filter: 'main',
                                      enable_ssl_verification: true,
                                      token: 'foofoofoo1234'
                                    })
    end

    it 'creates the correct resource' do
      expect(a_post('/groups/3/hooks')
        .with(body: { url: 'http://example.com', push_events: true, push_events_branch_filter: 'main', enable_ssl_verification: true, token: 'foofoofoo1234' })).to have_been_made
    end

    it 'returns the created group hook matching the format of GET hook' do
      expect(@hook).to be_a Gitlab::ObjectifiedHash
      expect(@hook.url).to eq('http://example.com/hook')
    end
  end

  describe '.edit_group_hook(group_id, hook_id, url)' do
    before do
      stub_post('/groups/3/hooks/1', 'group_hook')
      @hook = Gitlab.edit_group_hook(3, 1, 'http://example.com', { push_events: false, token: 'foofoofoo1234' })
    end

    it 'updates the correct resource' do
      expect(a_post('/groups/3/hooks/1')
        .with(body: { url: 'http://example.com', push_events: false, token: 'foofoofoo1234' })).to have_been_made
    end

    it 'returns the updated group hook resource' do
      expect(@hook).to be_a Gitlab::ObjectifiedHash
      expect(@hook.url).to eq('http://example.com/hook')
    end
  end

  describe '.delete_group_hook(group_id, hook_id)' do
    before do
      stub_delete('/groups/3/hooks/1', 'group_hook_delete')
      @hook = Gitlab.delete_group_hook(3, 1)
    end

    it 'delete the resource' do
      expect(a_delete('/groups/3/hooks/1')).to have_been_made
    end

    it 'returns false in test but in real life it returns status without a body which is converted to ObjectifiedHash' do
      expect(@hook).to be(false)
    end
  end

  describe 'group access tokens' do
    describe 'get all' do
      before do
        stub_get('/groups/2/access_tokens', 'group_access_token_get_all')
        @tokens = Gitlab.group_access_tokens(2)
      end

      it 'gets the correct resource' do
        expect(a_get('/groups/2/access_tokens')).to have_been_made
      end

      it 'gets an array of group access tokens' do
        expect(@tokens.first.id).to eq(2)
        expect(@tokens.last.id).to eq(3)
      end
    end

    describe 'get one' do
      before do
        stub_get('/groups/2/access_tokens/2', 'group_access_token_get')
        @token = Gitlab.group_access_token(2, 2)
      end

      it 'gets the correct resource' do
        expect(a_get('/groups/2/access_tokens/2')).to have_been_made
      end

      it 'gets a group access token' do
        expect(@token.user_id).to eq(2)
        expect(@token.id).to eq(2)
      end
    end

    describe 'create' do
      before do
        stub_post('/groups/2/access_tokens', 'group_access_token_create')
        @token = Gitlab.create_group_access_token(2, 'mytoken', ['api'])
      end

      it 'gets the correct resource' do
        expect(a_post('/groups/2/access_tokens').with(body: 'name=mytoken&scopes%5B%5D=api')).to have_been_made
      end

      it 'returns a valid group access token' do
        expect(@token.user_id).to eq(2)
        expect(@token.id).to eq(2)
        expect(@token.active).to be_truthy
        expect(@token.token).to eq('zMrP_vusadyipEaqued1')
      end
    end

    describe 'revoke' do
      before do
        stub_request(:delete, "#{Gitlab.endpoint}/groups/2/access_tokens/2")
          .with(headers: { 'PRIVATE-TOKEN' => Gitlab.private_token })
          .to_return(status: 204)
        @token = Gitlab.revoke_group_access_token(2, 2)
      end

      it 'removes a token' do
        expect(a_delete('/groups/2/access_tokens/2')).to have_been_made
        expect(@token.to_hash).to be_empty
      end
    end
  end
end
