require 'spec_helper'

describe Gitlab::PageLinks do
  before do
    @page_links = Gitlab::PageLinks.new('Link' => "<http://example.com/api/v3/projects?page=1&per_page=5>; rel=\"first\", <http://example.com/api/v3/projects?page=20&per_page=5>; rel=\"last\", <http://example.com/api/v3/projects?page=7&per_page=5>; rel=\"prev\", <http://example.com/api/v3/projects?page=9&per_page=5>; rel=\"next\"")
  end

  context '.extract_links' do
    it 'should extract link header appropriately' do
      expect(@page_links.last).to eql 'http://example.com/api/v3/projects?page=20&per_page=5'
      expect(@page_links.first).to eql 'http://example.com/api/v3/projects?page=1&per_page=5'
      expect(@page_links.next).to eql 'http://example.com/api/v3/projects?page=9&per_page=5'
      expect(@page_links.prev).to eql 'http://example.com/api/v3/projects?page=7&per_page=5'
    end
  end
end
