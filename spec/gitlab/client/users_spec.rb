# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.users' do
    before do
      stub_get('/users', 'users')
      @users = Gitlab.users
    end

    it 'gets the correct resource' do
      expect(a_get('/users')).to have_been_made
    end

    it 'returns a paginated response of users' do
      expect(@users).to be_a Gitlab::PaginatedResponse
      expect(@users.first.email).to eq('john@example.com')
    end
  end

  describe '.user' do
    context 'with user ID passed' do
      before do
        stub_get('/users/1', 'user')
        @user = Gitlab.user(1)
      end

      it 'gets the correct resource' do
        expect(a_get('/users/1')).to have_been_made
      end

      it 'returns information about a user' do
        expect(@user.email).to eq('john@example.com')
      end
    end

    context 'without user ID passed' do
      before do
        stub_get('/user', 'user')
        @user = Gitlab.user
      end

      it 'gets the correct resource' do
        expect(a_get('/user')).to have_been_made
      end

      it 'returns information about an authorized user' do
        expect(@user.email).to eq('john@example.com')
      end
    end
  end

  describe '.create_user' do
    context 'when successful request' do
      before do
        stub_post('/users', 'user')
        @user = Gitlab.create_user('email', 'pass', 'john.smith')
      end

      it 'gets the correct resource' do
        body = { email: 'email', password: 'pass', username: 'john.smith', name: 'email' }
        expect(a_post('/users').with(body: body)).to have_been_made
      end

      it 'returns information about a created user' do
        expect(@user.email).to eq('john@example.com')
      end
    end

    context 'when bad request' do
      it 'throws an exception' do
        stub_post('/users', 'error_already_exists', 409)
        expect do
          Gitlab.create_user('email', 'pass', 'john.smith')
        end.to raise_error(Gitlab::Error::Conflict, "Server responded with code 409, message: 409 Already exists. Request URI: #{Gitlab.endpoint}/users")
      end
    end

    context 'when not enough arguments' do
      it 'throws an exception' do
        expect do
          Gitlab.create_user('email', 'pass')
        end.to raise_error(ArgumentError, 'Missing required parameters')
      end
    end
  end

  describe '.create_user_with_userame' do
    context 'when successful request' do
      before do
        stub_post('/users', 'user')
        @user = Gitlab.create_user('email', 'pass', 'username')
      end

      it 'gets the correct resource' do
        body = { email: 'email', password: 'pass', username: 'username', name: 'email' }
        expect(a_post('/users').with(body: body)).to have_been_made
      end

      it 'returns information about a created user' do
        expect(@user.email).to eq('john@example.com')
      end
    end

    context 'when bad request' do
      it 'throws an exception' do
        stub_post('/users', 'error_already_exists', 409)
        expect do
          Gitlab.create_user('email', 'pass', 'username')
        end.to raise_error(Gitlab::Error::Conflict, "Server responded with code 409, message: 409 Already exists. Request URI: #{Gitlab.endpoint}/users")
      end
    end
  end

  describe '.edit_user' do
    before do
      @options = { name: 'Roberto' }
      stub_put('/users/1', 'user').with(body: @options)
      @user = Gitlab.edit_user(1, @options)
    end

    it 'gets the correct resource' do
      expect(a_put('/users/1').with(body: @options)).to have_been_made
    end
  end

  describe '.delete_user' do
    before do
      stub_delete('/users/1', 'user')
      @user = Gitlab.delete_user(1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/users/1')).to have_been_made
    end

    it 'returns information about a deleted user' do
      expect(@user.email).to eq('john@example.com')
    end
  end

  describe '.block_user' do
    before do
      stub_post('/users/1/block', 'user_block_unblock')
      @result = Gitlab.block_user(1)
    end

    it 'gets the correct resource' do
      expect(a_post('/users/1/block')).to have_been_made
    end

    it 'returns boolean' do
      expect(@result).to eq(true)
    end
  end

  describe '.unblock_user' do
    before do
      stub_post('/users/1/unblock', 'user_block_unblock')
      @result = Gitlab.unblock_user(1)
    end

    it 'gets the correct resource' do
      expect(a_post('/users/1/unblock')).to have_been_made
    end

    it 'returns boolean' do
      expect(@result).to eq(true)
    end
  end

  describe '.approve_user' do
    before do
      stub_post('/users/1/approve', 'user_approve')
      @result = Gitlab.approve_user(1)
    end

    it 'gets the correct resource' do
      expect(a_post('/users/1/approve')).to have_been_made
    end

    it 'returns boolean' do
      expect(@result).to eq(true)
    end
  end

  describe '.session' do
    after do
      Gitlab.endpoint = 'https://api.example.com'
      Gitlab.private_token = 'secret'
    end

    before do
      stub_request(:post, "#{Gitlab.endpoint}/session")
        .to_return(body: load_fixture('session'), status: 200)
      @session = Gitlab.session('email', 'pass')
    end

    context 'when endpoint is not set' do
      it 'raises Error::MissingCredentials' do
        Gitlab.endpoint = nil
        expect do
          Gitlab.session('email', 'pass')
        end.to raise_error(Gitlab::Error::MissingCredentials, 'Please set an endpoint to API')
      end
    end

    context 'when private_token is not set' do
      it 'does not raise Error::MissingCredentials' do
        Gitlab.private_token = nil
        expect { Gitlab.session('email', 'pass') }.not_to raise_error
      end
    end

    context 'when endpoint is set' do
      it 'gets the correct resource' do
        expect(a_request(:post, "#{Gitlab.endpoint}/session")).to have_been_made
      end

      it 'returns information about a created session' do
        expect(@session.email).to eq('john@example.com')
        expect(@session.private_token).to eq('qEsq1pt6HJPaNciie3MG')
      end
    end
  end

  describe '.activities' do
    before do
      stub_get('/user/activities', 'activities')
      @activities = Gitlab.activities
    end

    it 'gets the correct resource' do
      expect(a_get('/user/activities')).to have_been_made
    end

    it 'returns a paginated response of user activity' do
      expect(@activities).to be_a Gitlab::PaginatedResponse
      expect(@activities.first.username).to eq('someuser')
    end
  end

  describe '.ssh_keys' do
    context 'with user ID passed' do
      before do
        stub_get('/users/1/keys', 'keys')
        @keys = Gitlab.ssh_keys(user_id: 1)
      end

      it 'gets the correct resource' do
        expect(a_get('/users/1/keys')).to have_been_made
      end

      it 'returns a paginated response of SSH keys' do
        expect(@keys).to be_a Gitlab::PaginatedResponse
        expect(@keys.first.title).to eq('narkoz@helium')
      end
    end

    context 'without user ID passed' do
      before do
        stub_get('/user/keys', 'keys')
        @keys = Gitlab.ssh_keys
      end

      it 'gets the correct resource' do
        expect(a_get('/user/keys')).to have_been_made
      end

      it 'returns a paginated response of SSH keys' do
        expect(@keys).to be_a Gitlab::PaginatedResponse
        expect(@keys.first.title).to eq('narkoz@helium')
      end
    end
  end

  describe '.ssh_key' do
    before do
      stub_get('/user/keys/1', 'key')
      @key = Gitlab.ssh_key(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/user/keys/1')).to have_been_made
    end

    it 'returns information about an SSH key' do
      expect(@key.title).to eq('narkoz@helium')
    end
  end

  describe '.create_ssh_key' do
    describe 'without user ID' do
      before do
        stub_post('/user/keys', 'key')
        @key = Gitlab.create_ssh_key('title', 'body')
      end

      it 'gets the correct resource' do
        body = { title: 'title', key: 'body' }
        expect(a_post('/user/keys').with(body: body)).to have_been_made
      end

      it 'returns information about a created SSH key' do
        expect(@key.title).to eq('narkoz@helium')
      end
    end

    describe 'with user ID' do
      before do
        stub_post('/users/1/keys', 'key')
        @options = { user_id: 1 }
        @key = Gitlab.create_ssh_key('title', 'body', @options)
      end

      it 'gets the correct resource' do
        body = { title: 'title', key: 'body' }
        expect(a_post('/users/1/keys').with(body: body)).to have_been_made
      end

      it 'returns information about a created SSH key' do
        expect(@key.title).to eq('narkoz@helium')
      end
    end
  end

  describe '.delete_ssh_key' do
    describe 'without user ID' do
      before do
        stub_delete('/user/keys/1', 'key')
        @key = Gitlab.delete_ssh_key(1)
      end

      it 'gets the correct resource' do
        expect(a_delete('/user/keys/1')).to have_been_made
      end

      it 'returns information about a deleted SSH key' do
        expect(@key.title).to eq('narkoz@helium')
      end
    end

    describe 'with user ID' do
      before do
        stub_delete('/users/1/keys/1', 'key')
        @options = { user_id: 1 }
        @key = Gitlab.delete_ssh_key(1, @options)
      end

      it 'gets the correct resource' do
        expect(a_delete('/users/1/keys/1')).to have_been_made
      end

      it 'returns information about a deleted SSH key' do
        expect(@key.title).to eq('narkoz@helium')
      end
    end
  end

  describe '.emails' do
    describe 'without user ID' do
      before do
        stub_get('/user/emails', 'user_emails')
        @emails = Gitlab.emails
      end

      it 'gets the correct resource' do
        expect(a_get('/user/emails')).to have_been_made
      end

      it 'returns a information about a emails of user' do
        email = @emails.first
        expect(email.id).to eq 1
        expect(email.email).to eq('email@example.com')
      end
    end

    describe 'with user ID' do
      before do
        stub_get('/users/2/emails', 'user_emails')
        @emails = Gitlab.emails(2)
      end

      it 'gets the correct resource' do
        expect(a_get('/users/2/emails')).to have_been_made
      end

      it 'returns a information about a emails of user' do
        email = @emails.first
        expect(email.id).to eq 1
        expect(email.email).to eq('email@example.com')
      end
    end
  end

  describe '.email' do
    before do
      stub_get('/user/emails/2', 'user_email')
      @email = Gitlab.email(2)
    end

    it 'gets the correct resource' do
      expect(a_get('/user/emails/2')).to have_been_made
    end

    it 'returns a information about a email of user' do
      expect(@email.id).to eq 1
      expect(@email.email).to eq('email@example.com')
    end
  end

  describe '.add_email' do
    describe 'without user ID' do
      before do
        stub_post('/user/emails', 'user_email')
        @email = Gitlab.add_email('email@example.com')
      end

      it 'gets the correct resource' do
        body = { email: 'email@example.com' }
        expect(a_post('/user/emails').with(body: body)).to have_been_made
      end

      it 'returns information about a new email' do
        expect(@email.id).to eq(1)
        expect(@email.email).to eq('email@example.com')
      end
    end

    describe 'with user ID' do
      before do
        stub_post('/users/2/emails', 'user_email')
        @email = Gitlab.add_email('email@example.com', 2)
      end

      it 'gets the correct resource' do
        body = { email: 'email@example.com' }
        expect(a_post('/users/2/emails').with(body: body)).to have_been_made
      end

      it 'returns information about a new email' do
        expect(@email.id).to eq(1)
        expect(@email.email).to eq('email@example.com')
      end
    end
  end

  describe '.delete_email' do
    describe 'without user ID' do
      before do
        stub_delete('/user/emails/1', 'user_email')
        @email = Gitlab.delete_email(1)
      end

      it 'gets the correct resource' do
        expect(a_delete('/user/emails/1')).to have_been_made
      end

      it 'returns information about a deleted email' do
        expect(@email).to be_truthy
      end
    end

    describe 'with user ID' do
      before do
        stub_delete('/users/2/emails/1', 'user_email')
        @email = Gitlab.delete_email(1, 2)
      end

      it 'gets the correct resource' do
        expect(a_delete('/users/2/emails/1')).to have_been_made
      end

      it 'returns information about a deleted email' do
        expect(@email).to be_truthy
      end
    end
  end

  describe '.user_search' do
    before do
      stub_get('/users?search=User', 'user_search')
      @users = Gitlab.user_search('User')
    end

    it 'gets the correct resource' do
      expect(a_get('/users?search=User')).to have_been_made
    end

    it 'returns an array of users found' do
      expect(@users.first.id).to eq(1)
      expect(@users.last.id).to eq(2)
    end
  end

  describe '.user_custom_attributes' do
    before do
      stub_get('/users/2/custom_attributes', 'user_custom_attributes')
      @custom_attributes = Gitlab.user_custom_attributes(2)
    end

    it 'gets the correct resource' do
      expect(a_get('/users/2/custom_attributes')).to have_been_made
    end

    it 'returns a information about a custom_attribute of user' do
      expect(@custom_attributes.first.key).to eq 'somekey'
      expect(@custom_attributes.last.value).to eq('somevalue2')
    end
  end

  describe '.user_custom_attribute' do
    before do
      stub_get('/users/2/custom_attributes/some_new_key', 'user_custom_attribute')
      @custom_attribute = Gitlab.user_custom_attribute('some_new_key', 2)
    end

    it 'gets the correct resource' do
      expect(a_get('/users/2/custom_attributes/some_new_key')).to have_been_made
    end

    it 'returns a information about the single custom_attribute of user' do
      expect(@custom_attribute.key).to eq 'some_new_key'
      expect(@custom_attribute.value).to eq('some_new_value')
    end
  end

  describe '.add_custom_attribute' do
    describe 'with user ID' do
      before do
        stub_put('/users/2/custom_attributes/some_new_key', 'user_custom_attribute')
        @custom_attribute = Gitlab.add_user_custom_attribute('some_new_key', 'some_new_value', 2)
      end

      it 'gets the correct resource' do
        body = { value: 'some_new_value' }
        expect(a_put('/users/2/custom_attributes/some_new_key').with(body: body)).to have_been_made
        expect(a_put('/users/2/custom_attributes/some_new_key')).to have_been_made
      end

      it 'returns information about a new custom attribute' do
        expect(@custom_attribute.key).to eq 'some_new_key'
        expect(@custom_attribute.value).to eq 'some_new_value'
      end
    end
  end

  describe '.delete_custom_attribute' do
    describe 'with user ID' do
      before do
        stub_delete('/users/2/custom_attributes/some_new_key', 'user_custom_attribute')
        @custom_attribute = Gitlab.delete_user_custom_attribute('some_new_key', 2)
      end

      it 'gets the correct resource' do
        expect(a_delete('/users/2/custom_attributes/some_new_key')).to have_been_made
      end

      it 'returns information about a deleted custom_attribute' do
        expect(@custom_attribute).to be_truthy
      end
    end
  end

  describe 'impersonation tokens' do
    describe 'get all' do
      before do
        stub_get('/users/2/impersonation_tokens', 'impersonation_get_all')
        @tokens = Gitlab.user_impersonation_tokens(2)
      end

      it 'gets the correct resource' do
        expect(a_get('/users/2/impersonation_tokens')).to have_been_made
      end

      it 'gets an array of user impersonation tokens' do
        expect(@tokens.first.id).to eq(2)
        expect(@tokens.last.id).to eq(3)
        expect(@tokens.first.impersonation).to be_truthy
        expect(@tokens.last.impersonation).to be_truthy
      end
    end
  end

  describe 'get one' do
    before do
      stub_get('/users/2/impersonation_tokens/2', 'impersonation_get')
      @token = Gitlab.user_impersonation_token(2, 2)
    end

    it 'gets the correct resource' do
      expect(a_get('/users/2/impersonation_tokens/2')).to have_been_made
    end

    it 'gets a user impersonation token' do
      expect(@token.user_id).to eq(2)
      expect(@token.id).to eq(2)
      expect(@token.impersonation).to be_truthy
    end
  end

  describe 'create' do
    before do
      stub_post('/users/2/impersonation_tokens', 'impersonation_create')
      @token = Gitlab.create_user_impersonation_token(2, 'mytoken', ['api'])
    end

    it 'gets the correct resource' do
      expect(a_post('/users/2/impersonation_tokens').with(body: 'name=mytoken&scopes%5B%5D=api')).to have_been_made
    end

    it 'returns a valid impersonation token' do
      expect(@token.user_id).to eq(2)
      expect(@token.id).to eq(2)
      expect(@token.impersonation).to be_truthy
      expect(@token.active).to be_truthy
      expect(@token.token).to eq('EsMo-vhKfXGwX9RKrwiy')
    end
  end

  describe 'revoke' do
    before do
      stub_request(:delete, "#{Gitlab.endpoint}/users/2/impersonation_tokens/2")
        .with(headers: { 'PRIVATE-TOKEN' => Gitlab.private_token })
        .to_return(status: 204)
      @token = Gitlab.revoke_user_impersonation_token(2, 2)
    end

    it 'removes a token' do
      expect(a_delete('/users/2/impersonation_tokens/2')).to have_been_made
      expect(@token.to_hash).to be_empty
    end
  end
end
