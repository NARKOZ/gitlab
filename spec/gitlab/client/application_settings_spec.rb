# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  it { is_expected.to respond_to :application_settings }
  it { is_expected.to respond_to :edit_application_settings }

  describe '.application_settings' do
    before do
      stub_get('/application/settings', 'application_settings')
      @application_settings = Gitlab.application_settings
    end

    it 'gets the correct resource' do
      expect(a_get('/application/settings')).to have_been_made
    end

    it 'returns a paginated response of projects' do
      expect(@application_settings).to be_a Gitlab::ObjectifiedHash
      expect(@application_settings.default_projects_limit).to eq(100_000)
    end
  end

  describe '.edit_application_settings' do
    before do
      stub_put('/application/settings', 'application_settings').with(body: { signup_enabled: true })
      @edited_application_settings = Gitlab.edit_application_settings(signup_enabled: true)
    end

    it 'gets the correct resource' do
      expect(a_put('/application/settings').with(body: { signup_enabled: true })).to have_been_made
    end

    it 'returns information about an edited project' do
      expect(@edited_application_settings.signup_enabled).to eq(true)
    end
  end
end
