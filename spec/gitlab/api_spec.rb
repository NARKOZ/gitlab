# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::API do
  let(:default_headers) { subject.class.default_options[:headers] }

  describe '.default_options[:headers]' do
    it "has 'User-Agent'" do
      expect(default_headers).to include('User-Agent' => Gitlab::Configuration::DEFAULT_USER_AGENT)
    end
  end
end
