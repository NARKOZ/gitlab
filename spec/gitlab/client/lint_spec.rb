# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.validate_gitlab_ci_yml' do
    context 'when valid content' do
      before do
        stub_post('/lint', 'valid_content_gitlab_ci_yml')
        @lint_response = Gitlab.validate_gitlab_ci_yml('{ "image": "ruby:2.6", "services": ["postgres"], "before_script": ["bundle install", "bundle exec rake db:create"], "variables": {"DB_NAME": "postgres"}, "types": ["test", "deploy", "notify"], "rspec": { "script": "rake spec", "tags": ["ruby", "postgres"], "only": ["branches"]}}')
      end

      it 'gets the correct resource' do
        expect(a_post('/lint')
          .with(body: { content: '{ "image": "ruby:2.6", "services": ["postgres"], "before_script": ["bundle install", "bundle exec rake db:create"], "variables": {"DB_NAME": "postgres"}, "types": ["test", "deploy", "notify"], "rspec": { "script": "rake spec", "tags": ["ruby", "postgres"], "only": ["branches"]}}' })).to have_been_made
      end

      it 'returns correct information about validity of the response' do
        expect(@lint_response.status).to eq('valid')
        expect(@lint_response.errors).to eq([])
      end
    end
    context 'when invalid content' do
      before do
        stub_post('/lint', 'invalid_content_gitlab_ci_yml')
        @lint_response = Gitlab.validate_gitlab_ci_yml('Not a valid content')
      end

      it 'gets the correct resource' do
        expect(a_post('/lint')
          .with(body: { content: 'Not a valid content' })).to have_been_made
      end

      it 'returns correct information about validity of the response' do
        expect(@lint_response.status).to eq('invalid')
        expect(@lint_response.errors).to include('variables config should be a hash of key value pairs')
      end
    end
    context 'when without content attribute' do
      before do
        stub_post('/lint', 'no_content_gitlab_ci_yml')
        @lint_response = Gitlab.validate_gitlab_ci_yml(nil)
      end

      it 'gets the correct resource' do
        expect(a_post('/lint')).to have_been_made
      end

      it 'returns correct information about validity of the response' do
        expect(@lint_response.error).to eq('content is missing')
      end
    end
  end
end
