# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  it { is_expected.to respond_to :search_projects }

  describe '.projects' do
    before do
      stub_get('/projects', 'projects')
      @projects = Gitlab.projects
    end

    it 'gets the correct resource' do
      expect(a_get('/projects')).to have_been_made
    end

    it 'returns a paginated response of projects' do
      expect(@projects).to be_a Gitlab::PaginatedResponse
      expect(@projects.first.name).to eq('Brute')
      expect(@projects.first.owner.name).to eq('John Smith')
    end
  end

  describe '.project_search' do
    before do
      stub_get('/projects?search=Gitlab', 'project_search')
      @project_search = Gitlab.project_search('Gitlab')
    end

    it 'gets the correct resource' do
      expect(a_get('/projects?search=Gitlab')).to have_been_made
    end

    it 'returns a paginated response of projects found' do
      expect(@project_search).to be_a Gitlab::PaginatedResponse
      expect(@project_search.first.name).to eq('Gitlab')
      expect(@project_search.first.owner.name).to eq('John Smith')
    end
  end

  describe '.project' do
    before do
      stub_get('/projects/3', 'project')
      @project = Gitlab.project(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3')).to have_been_made
    end

    it 'returns information about a project' do
      expect(@project.name).to eq('Gitlab')
      expect(@project.owner.name).to eq('John Smith')
    end
  end

  describe '.create_project' do
    before do
      stub_post('/projects', 'project')
      @project = Gitlab.create_project('Gitlab')
    end

    it 'gets the correct resource' do
      expect(a_post('/projects')).to have_been_made
    end

    it 'returns information about a created project' do
      expect(@project.name).to eq('Gitlab')
      expect(@project.owner.name).to eq('John Smith')
    end
  end

  describe '.create_project for user' do
    before do
      stub_post('/users', 'user')
      @owner = Gitlab.create_user('john@example.com', 'pass', name: 'John Owner')
      stub_post("/projects/user/#{@owner.id}", 'project_for_user')
      @project = Gitlab.create_project('Brute', user_id: @owner.id)
    end

    it 'returns information about a created project' do
      expect(@project.name).to eq('Brute')
      expect(@project.owner.name).to eq('John Owner')
    end
  end

  describe '.delete_project' do
    before do
      stub_delete('/projects/Gitlab', 'project')
      @project = Gitlab.delete_project('Gitlab')
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/Gitlab')).to have_been_made
    end

    it 'returns information about a deleted project' do
      expect(@project.name).to eq('Gitlab')
      expect(@project.owner.name).to eq('John Smith')
    end
  end

  describe '.create_fork' do
    context 'without sudo option' do
      before do
        stub_post('/projects/3/fork', 'project_fork')
        @project = Gitlab.create_fork(3)
      end

      it 'posts to the correct resource' do
        expect(a_post('/projects/3/fork')).to have_been_made
      end

      it 'returns information about the forked project' do
        expect(@project.forked_from_project.id).to eq(3)
        expect(@project.id).to eq(20)
      end
    end

    context 'with the sudo option' do
      before do
        stub_post('/projects/3/fork', 'project_forked_for_user')
        @sudoed_username = 'jack.smith'
        @project = Gitlab.create_fork(3, sudo: @sudoed_username)
      end

      it 'posts to the correct resource' do
        expect(a_post('/projects/3/fork')).to have_been_made
      end

      it 'returns information about the forked project' do
        expect(@project.forked_from_project.id).to eq(3)
        expect(@project.id).to eq(20)
        expect(@project.owner.username).to eq(@sudoed_username)
      end
    end
  end

  describe '.project_forks' do
    before do
      stub_get('/projects/3/forks', 'project_forks')
      @project_forks = Gitlab.project_forks(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/forks')).to have_been_made
    end

    it 'returns a paginated response of projects found' do
      expect(@project_forks).to be_a Gitlab::PaginatedResponse
      expect(@project_forks.first.name).to eq('gitlab')
      expect(@project_forks.first.owner.name).to eq('Administrator')
    end
  end

  describe '.team_members' do
    before do
      stub_get('/projects/3/members', 'team_members')
      @team_members = Gitlab.team_members(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/members')).to have_been_made
    end

    it 'returns a paginated response of team members' do
      expect(@team_members).to be_a Gitlab::PaginatedResponse
      expect(@team_members.first.name).to eq('John Smith')
    end
  end

  describe '.team_member' do
    before do
      stub_get('/projects/3/members/1', 'team_member')
      @team_member = Gitlab.team_member(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/members/1')).to have_been_made
    end

    it 'returns information about a team member' do
      expect(@team_member.name).to eq('John Smith')
    end
  end

  describe '.add_team_member' do
    before do
      stub_post('/projects/3/members', 'team_member')
      @team_member = Gitlab.add_team_member(3, 1, 40, expires_at: '2018-12-31')
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/members')
          .with(body: { user_id: '1', access_level: '40', expires_at: '2018-12-31' })).to have_been_made
    end

    it 'returns information about an added team member' do
      expect(@team_member.name).to eq('John Smith')
      expect(@team_member.expires_at).to eq('2018-12-31T00:00:00Z')
    end
  end

  describe '.edit_team_member' do
    before do
      stub_put('/projects/3/members/1', 'team_member')
      @team_member = Gitlab.edit_team_member(3, 1, 40, expires_at: '2018-12-31')
    end

    it 'gets the correct resource' do
      expect(a_put('/projects/3/members/1')
          .with(body: { access_level: '40', expires_at: '2018-12-31' })).to have_been_made
    end

    it 'returns information about an edited team member' do
      expect(@team_member.name).to eq('John Smith')
      expect(@team_member.expires_at).to eq('2018-12-31T00:00:00Z')
    end
  end

  describe '.remove_team_member' do
    before do
      stub_delete('/projects/3/members/1', 'team_member')
      @team_member = Gitlab.remove_team_member(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/3/members/1')).to have_been_made
    end

    it 'returns information about a removed team member' do
      expect(@team_member.name).to eq('John Smith')
    end
  end

  describe '.project_hooks' do
    before do
      stub_get('/projects/1/hooks', 'project_hooks')
      @hooks = Gitlab.project_hooks(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/hooks')).to have_been_made
    end

    it 'returns a paginated response of hooks' do
      expect(@hooks).to be_a Gitlab::PaginatedResponse
      expect(@hooks.first.url).to eq('https://api.example.net/v1/webhooks/ci')
    end
  end

  describe '.project_hook' do
    before do
      stub_get('/projects/1/hooks/1', 'project_hook')
      @hook = Gitlab.project_hook(1, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/hooks/1')).to have_been_made
    end

    it 'returns information about a hook' do
      expect(@hook.url).to eq('https://api.example.net/v1/webhooks/ci')
    end
  end

  describe '.add_project_hook' do
    context 'without specified events' do
      before do
        stub_post('/projects/1/hooks', 'project_hook')
        @hook = Gitlab.add_project_hook(1, 'https://api.example.net/v1/webhooks/ci')
      end

      it 'gets the correct resource' do
        body = { url: 'https://api.example.net/v1/webhooks/ci' }
        expect(a_post('/projects/1/hooks').with(body: body)).to have_been_made
      end

      it 'returns information about an added hook' do
        expect(@hook.url).to eq('https://api.example.net/v1/webhooks/ci')
      end
    end

    context 'with specified events' do
      before do
        stub_post('/projects/1/hooks', 'project_hook')
        @hook = Gitlab.add_project_hook(1, 'https://api.example.net/v1/webhooks/ci', push_events: true, merge_requests_events: true)
      end

      it 'gets the correct resource' do
        body = { url: 'https://api.example.net/v1/webhooks/ci', push_events: 'true', merge_requests_events: 'true' }
        expect(a_post('/projects/1/hooks').with(body: body)).to have_been_made
      end

      it 'returns information about an added hook' do
        expect(@hook.url).to eq('https://api.example.net/v1/webhooks/ci')
      end
    end
  end

  describe '.edit_project_hook' do
    before do
      stub_put('/projects/1/hooks/1', 'project_hook')
      @hook = Gitlab.edit_project_hook(1, 1, 'https://api.example.net/v1/webhooks/ci')
    end

    it 'gets the correct resource' do
      body = { url: 'https://api.example.net/v1/webhooks/ci' }
      expect(a_put('/projects/1/hooks/1').with(body: body)).to have_been_made
    end

    it 'returns information about an edited hook' do
      expect(@hook.url).to eq('https://api.example.net/v1/webhooks/ci')
    end
  end

  describe '.edit_project' do
    context 'using project ID' do
      before do
        stub_put('/projects/3', 'project_edit').with(body: { name: 'Gitlab-edit' })
        @edited_project = Gitlab.edit_project(3, name: 'Gitlab-edit')
      end

      it 'gets the correct resource' do
        expect(a_put('/projects/3').with(body: { name: 'Gitlab-edit' })).to have_been_made
      end

      it 'returns information about an edited project' do
        expect(@edited_project.name).to eq('Gitlab-edit')
      end
    end

    context 'using namespaced project path' do
      it 'encodes the path properly' do
        stub = stub_put('/projects/namespace%2Fpath', 'project_edit').with(body: { name: 'Gitlab-edit' })
        Gitlab.edit_project('namespace/path', name: 'Gitlab-edit')
        expect(stub).to have_been_requested
      end
    end
  end

  describe '.delete_project_hook' do
    context 'when empty response' do
      before do
        stub_request(:delete, "#{Gitlab.endpoint}/projects/1/hooks/1")
          .with(headers: { 'PRIVATE-TOKEN' => Gitlab.private_token })
          .to_return(body: '')
        @hook = Gitlab.delete_project_hook(1, 1)
      end

      it 'gets the correct resource' do
        expect(a_delete('/projects/1/hooks/1')).to have_been_made
      end

      it 'returns false' do
        expect(@hook).to be(false)
      end
    end

    context 'when JSON response' do
      before do
        stub_delete('/projects/1/hooks/1', 'project_hook')
        @hook = Gitlab.delete_project_hook(1, 1)
      end

      it 'gets the correct resource' do
        expect(a_delete('/projects/1/hooks/1')).to have_been_made
      end

      it 'returns information about a deleted hook' do
        expect(@hook.url).to eq('https://api.example.net/v1/webhooks/ci')
      end
    end
  end

  describe '.push_rule' do
    before do
      stub_get('/projects/1/push_rule', 'push_rule')
      @push_rule = Gitlab.push_rule(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/push_rule')).to have_been_made
    end

    it 'returns information about a push rule' do
      expect(@push_rule.commit_message_regex).to eq('\\b[A-Z]{3}-[0-9]+\\b')
    end
  end

  describe '.add_push_rule' do
    before do
      stub_post('/projects/1/push_rule', 'push_rule')
      @push_rule = Gitlab.add_push_rule(1, deny_delete_tag: false, commit_message_regex: '\\b[A-Z]{3}-[0-9]+\\b')
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/1/push_rule')).to have_been_made
    end

    it 'returns information about an added push rule' do
      expect(@push_rule.commit_message_regex).to eq('\\b[A-Z]{3}-[0-9]+\\b')
    end
  end

  describe '.edit_push_rule' do
    before do
      stub_put('/projects/1/push_rule', 'push_rule')
      @push_rule = Gitlab.edit_push_rule(1, deny_delete_tag: false, commit_message_regex: '\\b[A-Z]{3}-[0-9]+\\b')
    end

    it 'gets the correct resource' do
      expect(a_put('/projects/1/push_rule')).to have_been_made
    end

    it 'returns information about an edited push rule' do
      expect(@push_rule.commit_message_regex).to eq('\\b[A-Z]{3}-[0-9]+\\b')
    end
  end

  describe '.delete_push_rule' do
    context 'when empty response' do
      before do
        stub_request(:delete, "#{Gitlab.endpoint}/projects/1/push_rule")
          .with(headers: { 'PRIVATE-TOKEN' => Gitlab.private_token })
          .to_return(body: '')
        @push_rule = Gitlab.delete_push_rule(1)
      end

      it 'gets the correct resource' do
        expect(a_delete('/projects/1/push_rule')).to have_been_made
      end

      it 'returns false' do
        expect(@push_rule).to be(false)
      end
    end

    context 'when JSON response' do
      before do
        stub_delete('/projects/1/push_rule', 'push_rule')
        @push_rule = Gitlab.delete_push_rule(1)
      end

      it 'gets the correct resource' do
        expect(a_delete('/projects/1/push_rule')).to have_been_made
      end

      it 'returns information about a deleted push rule' do
        expect(@push_rule.commit_message_regex).to eq('\\b[A-Z]{3}-[0-9]+\\b')
      end
    end
  end

  describe '.make_forked_from' do
    before do
      stub_post('/projects/42/fork/24', 'project_fork_link')
      @forked_project_link = Gitlab.make_forked_from(42, 24)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/42/fork/24')).to have_been_made
    end

    it 'returns information about a forked project' do
      expect(@forked_project_link.forked_from_project_id).to eq(24)
      expect(@forked_project_link.forked_to_project_id).to eq(42)
    end
  end

  describe '.remove_forked' do
    before do
      stub_delete('/projects/42/fork', 'project_fork_link')
      @forked_project_link = Gitlab.remove_forked(42)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/42/fork')).to have_been_made
    end

    it 'returns information about an unforked project' do
      expect(@forked_project_link.forked_to_project_id).to eq(42)
    end
  end

  describe '.deploy_keys' do
    before do
      stub_get('/projects/42/deploy_keys', 'project_keys')
      @deploy_keys = Gitlab.deploy_keys(42)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/42/deploy_keys')).to have_been_made
    end

    it 'returns project deploy keys' do
      expect(@deploy_keys).to be_a Gitlab::PaginatedResponse
      expect(@deploy_keys.first.id).to eq 2
      expect(@deploy_keys.first.title).to eq 'Key Title'
      expect(@deploy_keys.first.key).to match(/ssh-rsa/)
    end
  end

  describe '.deploy_key' do
    before do
      stub_get('/projects/42/deploy_keys/2', 'project_key')
      @deploy_key = Gitlab.deploy_key(42, 2)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/42/deploy_keys/2')).to have_been_made
    end

    it 'returns project deploy key' do
      expect(@deploy_key.id).to eq 2
      expect(@deploy_key.title).to eq 'Key Title'
      expect(@deploy_key.key).to match(/ssh-rsa/)
    end
  end

  describe '.create_deploy_key' do
    context 'no options' do
      before do
        stub_post('/projects/42/deploy_keys', 'project_key')
        @deploy_key = Gitlab.create_deploy_key(42, 'My Key', 'Key contents')
      end

      it 'gets the correct resource' do
        expect(a_post('/projects/42/deploy_keys')
          .with(body: { title: 'My Key', key: 'Key contents' })).to have_been_made
      end

      it 'returns information about a created key' do
        expect(@deploy_key.id).to eq(2)
      end
    end

    context 'some options' do
      before do
        stub_post('/projects/42/deploy_keys', 'project_key')
        @deploy_key = Gitlab.create_deploy_key(42, 'My Key', 'Key contents', can_push: true)
      end

      it 'gets the correct resource' do
        expect(a_post('/projects/42/deploy_keys')
          .with(body: { title: 'My Key', key: 'Key contents', can_push: true })).to have_been_made
      end

      it 'returns information about a created key' do
        expect(@deploy_key.id).to eq(2)
      end
    end
  end

  describe '.delete_deploy_key' do
    before do
      stub_delete('/projects/42/deploy_keys/2', 'project_key')
      @deploy_key = Gitlab.delete_deploy_key(42, 2)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/42/deploy_keys/2')).to have_been_made
    end

    it 'returns information about a deleted key' do
      expect(@deploy_key.id).to eq(2)
    end
  end

  describe '.enable_deploy_key' do
    before do
      stub_post('/projects/42/deploy_keys/2/enable', 'project_key')
      @deploy_key = Gitlab.enable_deploy_key(42, 2)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/42/deploy_keys/2/enable')
          .with(body: { id: '42', key_id: '2' })).to have_been_made
    end

    it 'returns information about an enabled key' do
      expect(@deploy_key.id).to eq(2)
    end
  end

  describe '.disable_deploy_key' do
    before do
      stub_post('/projects/42/deploy_keys/2/disable', 'project_key')
      @deploy_key = Gitlab.disable_deploy_key(42, 2)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/42/deploy_keys/2/disable')
          .with(body: { id: '42', key_id: '2' })).to have_been_made
    end

    it 'returns information about a disabled key' do
      expect(@deploy_key.id).to eq(2)
    end
  end

  describe '.share_project_with_group' do
    before do
      stub_post('/projects/3/share', 'group')
      @group = Gitlab.share_project_with_group(3, 10, 40)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/share')
          .with(body: { group_id: '10', group_access: '40' })).to have_been_made
    end

    it 'returns information about an added group' do
      expect(@group.id).to eq(10)
    end
  end

  describe '.unshare_project_with_group' do
    before do
      stub_delete('/projects/3/share/10', 'group')
      @group = Gitlab.unshare_project_with_group(3, 10)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/3/share/10')).to have_been_made
    end
  end

  describe '.transfer_project' do
    before do
      stub_put('/projects/3/transfer', 'transfer_project')
      @transfered_project = Gitlab.transfer_project(3, 'yolo')
    end

    it 'gets the correct resource' do
      expect(a_put('/projects/3/transfer')
          .with(body: { namespace: 'yolo' })).to have_been_made
    end

    it 'returns information about the transfered project' do
      expect(@transfered_project.id).to eq(1)
    end
  end

  describe '.star_project' do
    before do
      stub_post('/projects/3/star', 'project_star')
      @starred_project = Gitlab.star_project(3)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/star')).to have_been_made
    end

    it 'returns information about the starred project' do
      expect(@starred_project.id).to eq(3)
    end
  end

  describe '.unstar_project' do
    before do
      stub_delete('/projects/3/star', 'project_unstar')
      @unstarred_project = Gitlab.unstar_project(3)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/3/star')).to have_been_made
    end

    it 'returns information about the unstarred project' do
      expect(@unstarred_project.id).to eq(3)
    end
  end

  describe '.user_projects' do
    let(:user_id) { 1 }
    let(:project_id) { 1 }

    before do
      stub_get("/users/#{user_id}/projects", 'user_projects')
      @user_projects = Gitlab.user_projects(user_id)
    end

    it 'gets the correct resource' do
      expect(a_get("/users/#{user_id}/projects")).to have_been_made
    end

    it 'returns a paginated response of projects' do
      expect(@user_projects).to be_a Gitlab::PaginatedResponse
      expect(@user_projects.first.id).to eq(project_id)
      expect(@user_projects.first.owner.id).to eq(user_id)
    end
  end

  describe '.upload_file' do
    let(:id) { 1 }
    let(:file) { File.open(File::NULL, 'r') }

    before do
      stub_post("/projects/#{id}/uploads", 'upload_file')
      @file = Gitlab.upload_file(id, file)
    end

    it 'gets the correct resource' do
      expect(a_post("/projects/#{id}/uploads")).to have_been_made
    end

    it 'returns information about the uploaded file' do
      expect(@file.alt).to eq('null')
      expect(@file.url).to eq('/uploads/f22e67e35e1bcb339058212c54bb8772/null')
      expect(@file.markdown).to eq('[null](/uploads/f22e67e35e1bcb339058212c54bb8772/null)')
    end
  end

  describe '.project_templates' do
    before do
      stub_get('/projects/3/templates/licenses', 'project_templates')
      @project_templates = Gitlab.project_templates(3, 'licenses')
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/templates/licenses')).to have_been_made
    end

    it "returns a paginated response of project's templates" do
      expect(@project_templates).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.project_template' do
    context 'when dockerfiles' do
      before do
        stub_get('/projects/3/templates/dockerfiles/dock', 'dockerfile_project_template')
        @project_template = Gitlab.project_template(3, 'dockerfiles', 'dock')
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/3/templates/dockerfiles/dock')).to have_been_made
      end
    end

    context 'when licenses' do
      before do
        stub_get('/projects/3/templates/licenses/mit', 'license_project_template')
        @project_template = Gitlab.project_template(3, 'licenses', 'mit')
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/3/templates/licenses/mit')).to have_been_made
      end
    end
  end

  describe '.archive_project' do
    before do
      stub_post('/projects/3/archive', 'project_archive')
      @archived_project = Gitlab.archive_project('3')
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/archive')).to have_been_made
    end

    it 'returns information about a archived project' do
      expect(@archived_project.name).to eq('GitLab Community Edition')
      expect(@archived_project.archived).to eq(true)
    end
  end

  describe '.unarchive_project' do
    before do
      stub_post('/projects/3/unarchive', 'project_unarchive')
      @unarchived_project = Gitlab.unarchive_project('3')
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/unarchive')).to have_been_made
    end

    it 'returns information about a unarchived project' do
      expect(@unarchived_project.name).to eq('GitLab Community Edition')
      expect(@unarchived_project.archived).to eq(false)
    end
  end
end
