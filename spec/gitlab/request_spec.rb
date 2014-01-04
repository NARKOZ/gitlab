require 'spec_helper'

describe Gitlab::Request do
  after { Gitlab.reset }

  describe '.set_request_defaults' do
    context 'passing a nil as endpoint' do
      context 'passing a nil as private_token' do
        it 'should raise an Error::MissingCredentials with message '\
           '"Please set an endpoint to API"' do
          expect do
            subject.set_request_defaults(nil, nil)
          end.to raise_error(
            Gitlab::Error::MissingCredentials,
            'Please set an endpoint to API'
          )
        end
      end
      context 'passing a private_token' do
        it 'should raise an Error::MissingCredentials with message '\
           '"Please set an endpoint to API"' do
          expect do
            subject.set_request_defaults(nil, 'api-token')
          end.to raise_error(
            Gitlab::Error::MissingCredentials,
            'Please set an endpoint to API'
          )
        end
      end
    end
    context 'passing an endpoint' do
      context 'passing a nil as private_token' do
        it 'should not raise error' do
          expect do
            subject.set_request_defaults('http://host.com/api/v3', nil)
          end.to_not raise_error
        end
      end
      context 'passing an empty String as private_token' do
        it 'should raise an Error::MissingCredentials with message '\
           '"Please set a private_token for user"' do
          expect do
            subject.set_request_defaults('http://host.com/api/v3', '')
          end.to raise_error(
            Gitlab::Error::MissingCredentials,
            'Please set a private_token for user'
          )
        end
      end
      context 'passing a token as private_token' do
        it 'should not raise error' do
          expect do
            subject.set_request_defaults('http://host.com/api/v3', 'aeK3p')
          end.to_not raise_error
        end
      end
      context 'passing a private_token' do
        it 'should raise an Error::MissingCredentials with message '\
           '"Please set an endpoint to API"' do
          expect do
            subject.set_request_defaults(nil, 'api-token')
          end.to raise_error(
            Gitlab::Error::MissingCredentials,
            'Please set an endpoint to API'
          )
        end
      end
    end
  end
end
