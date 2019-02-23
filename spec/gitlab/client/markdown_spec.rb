# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.markdown' do
    before do
      stub_post('/markdown', 'markdown')
      Gitlab.markdown('Hello world! :tada:', gfm: true, project: 'group_example/project_example')
    end

    it 'gets the correct resource' do
      expect(a_post('/markdown')
        .with(body: { text: 'Hello world! :tada:', gfm: true, project: 'group_example/project_example' })).to have_been_made
    end
  end
end
