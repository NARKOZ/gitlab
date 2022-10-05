# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Headers::Total do
  before do
    @total = described_class.new('x-total' => ' 8 ')
  end

  describe '.extract_total' do
    it 'extracts total header appropriately' do
      expect(@total.total).to eql('8')
    end
  end
end
