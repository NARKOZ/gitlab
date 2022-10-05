# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Headers::PageLinks do
  before do
    @page_links = described_class.new('Link' => '<http://example.com/api/v3/projects?page=1&per_page=5>; rel="first", <http://example.com/api/v3/projects?page=20&per_page=5>; rel="last", <http://example.com/api/v3/projects?page=7&per_page=5>; rel="prev", <http://example.com/api/v3/projects?page=9&per_page=5>; rel="next"')
  end

  describe '.extract_links' do
    it 'extracts link header appropriately' do
      expect(@page_links.last).to eql 'http://example.com/api/v3/projects?page=20&per_page=5'
      expect(@page_links.first).to eql 'http://example.com/api/v3/projects?page=1&per_page=5'
      expect(@page_links.next).to eql 'http://example.com/api/v3/projects?page=9&per_page=5'
      expect(@page_links.prev).to eql 'http://example.com/api/v3/projects?page=7&per_page=5'
    end
  end
end
