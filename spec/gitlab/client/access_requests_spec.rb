# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.project_access_requests' do
    before do
      stub_get('/projects/1/access_requests', 'access_requests')
      @access_requests = Gitlab.project_access_requests(1)
    end

    it 'gets the correct resources' do
      expect(a_get('/projects/1/access_requests')).to have_been_made
    end

    it 'returns a paginated response of project access requests' do
      expect(@access_requests).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.group_access_requests' do
    before do
      stub_get('/groups/1/access_requests', 'access_requests')
      @access_requests = Gitlab.group_access_requests(1)
    end

    it 'gets the correct resources' do
      expect(a_get('/groups/1/access_requests')).to have_been_made
    end

    it 'returns a paginated response of group access requests' do
      expect(@access_requests).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.request_project_access' do
    before do
      stub_post('/projects/1/access_requests', 'access_request')
      @access_request = Gitlab.request_project_access(1)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/1/access_requests')).to have_been_made
    end
  end

  describe '.request_group_access' do
    before do
      stub_post('/groups/1/access_requests', 'access_request')
      @access_request = Gitlab.request_group_access(1)
    end

    it 'gets the correct resource' do
      expect(a_post('/groups/1/access_requests')).to have_been_made
    end
  end

  describe '.approve_project_access_request' do
    context 'When no access level is given' do
      before do
        stub_put('/projects/1/access_requests/1/approve', 'default_approved_access_request')
        @access_request = Gitlab.approve_project_access_request(1, 1)
      end

      it 'gets the correct resource' do
        expect(a_put('/projects/1/access_requests/1/approve')).to have_been_made
      end

      it 'returns information about the project access request' do
        expect(@access_request.access_level).to eq(30)
      end
    end

    context 'When access level is given' do
      before do
        stub_put('/projects/1/access_requests/1/approve', 'approved_access_request').with(body: { access_level: '20' })
        @access_request = Gitlab.approve_project_access_request(1, 1, access_level: '20')
      end

      it 'gets the correct resource' do
        expect(a_put('/projects/1/access_requests/1/approve')
               .with(body: { access_level: '20' })).to have_been_made
      end

      it 'returns information about the project access request' do
        expect(@access_request.access_level).to eq(20)
      end
    end
  end

  describe '.approve_group_access_request' do
    context 'When no access level is given' do
      before do
        stub_put('/groups/1/access_requests/1/approve', 'default_approved_access_request')
        @access_request = Gitlab.approve_group_access_request(1, 1)
      end

      it 'gets the correct resource' do
        expect(a_put('/groups/1/access_requests/1/approve')).to have_been_made
      end

      it 'returns information about the group access request' do
        expect(@access_request.access_level).to eq(30)
      end
    end

    context 'When access level is given' do
      before do
        stub_put('/groups/1/access_requests/1/approve', 'approved_access_request').with(body: { access_level: '20' })
        @access_request = Gitlab.approve_group_access_request(1, 1, access_level: '20')
      end

      it 'gets the correct resource' do
        expect(a_put('/groups/1/access_requests/1/approve')
               .with(body: { access_level: '20' })).to have_been_made
      end

      it 'returns information about the group access request' do
        expect(@access_request.access_level).to eq(20)
      end
    end
  end

  describe '.deny_project_access_request' do
    before do
      stub_delete('/projects/1/access_requests/1', 'access_request')
      @access_request = Gitlab.deny_project_access_request(1, 1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/1/access_requests/1')).to have_been_made
    end
  end

  describe '.deny_group_access_request' do
    before do
      stub_delete('/groups/1/access_requests/1', 'access_request')
      @access_request = Gitlab.deny_group_access_request(1, 1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/groups/1/access_requests/1')).to have_been_made
    end
  end
end
