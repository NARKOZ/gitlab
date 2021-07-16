# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.create_group_invites' do
    before do
      stub_post('/groups/3/invitations', 'group_invites_created')
      @label = Gitlab.create_group_invites(3, 'test@example.com', 40)
    end

    it 'gets the correct resource' do
      expect(a_post('/groups/3/invitations')
        .with(body: { email: 'test@example.com', access_level: 40 })).to have_been_made
    end
  end
end
