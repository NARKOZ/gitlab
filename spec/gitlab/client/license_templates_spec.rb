# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.license_templates' do
    before do
      stub_get('/templates/licenses', 'license_templates')
      @license_templates = Gitlab.license_templates
    end

    it 'gets the correct resource' do
      expect(a_get('/templates/licenses')).to have_been_made
    end

    it 'returns a paginated response of license templates' do
      expect(@license_templates).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.license_template' do
    before do
      stub_get('/templates/licenses/mit', 'license_template')
      @license_template = Gitlab.license_template('mit')
    end

    it 'gets the correct resource' do
      expect(a_get('/templates/licenses/mit')).to have_been_made
    end

    it 'returns the correct information about the license template' do
      expect(@license_template.key).to eq 'mit'
    end
  end
end
