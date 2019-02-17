# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.group_boards' do
    before do
      stub_get('/groups/5/boards', 'group_boards')
      @group_boards = Gitlab.group_boards(5)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/5/boards')).to have_been_made
    end

    it "returns a paginated response of group's boards" do
      expect(@group_boards).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.group_board' do
    before do
      stub_get('/groups/5/boards/1', 'group_board')
      @group_board = Gitlab.group_board(5, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/5/boards/1')).to have_been_made
    end

    it 'returns correct information about a group issue board' do
      expect(@group_board.id).to eq 1
    end
  end

  describe '.create_group_board' do
    before do
      stub_post('/groups/5/boards', 'group_board')
      @group_board = Gitlab.create_group_board(5, 'group issue board')
    end

    it 'gets the correct resource' do
      expect(a_post('/groups/5/boards')
        .with(body: { name: 'group issue board' })).to have_been_made
    end

    it 'returns information about a created group issue board' do
      expect(@group_board.name).to eq('group issue board')
    end
  end

  describe '.edit_group_board' do
    before do
      stub_put('/groups/5/boards/1', 'updated_group_board')
      @group_board = Gitlab.edit_group_board(5, 1, assignee_id: 1, milestone_id: 44)
    end

    it 'gets the correct resource' do
      expect(a_put('/groups/5/boards/1')
        .with(body: { assignee_id: 1, milestone_id: 44 })).to have_been_made
    end

    it 'returns information about an edited group issue board' do
      expect(@group_board.assignee.id).to eq(1)
      expect(@group_board.milestone.id).to eq(44)
    end
  end

  describe '.delete_group_board' do
    before do
      stub_delete('/groups/5/boards/1', 'empty')
      Gitlab.delete_group_board(5, 1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/groups/5/boards/1')).to have_been_made
    end
  end

  describe '.group_board_lists' do
    before do
      stub_get('/groups/5/boards/1/lists', 'group_board_lists')
      @group_board_lists = Gitlab.group_board_lists(5, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/5/boards/1/lists')).to have_been_made
    end

    it "returns a paginated response of group's board lists" do
      expect(@group_board_lists).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.group_board_list' do
    before do
      stub_get('/groups/5/boards/1/lists/1', 'group_board_list')
      @group_board_list = Gitlab.group_board_list(5, 1, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/5/boards/1/lists/1')).to have_been_made
    end

    it 'returns correct information about a group issue board list' do
      expect(@group_board_list.id).to eq 1
    end
  end

  describe '.create_group_board_list' do
    before do
      stub_post('/groups/5/boards/1/lists', 'group_board_list')
      @group_board_list = Gitlab.create_group_board_list(5, 1, 5)
    end

    it 'gets the correct resource' do
      expect(a_post('/groups/5/boards/1/lists')
        .with(body: { label_id: 5 })).to have_been_made
    end

    it 'returns information about a created group issue board list' do
      expect(@group_board_list.position).to eq(1)
    end
  end

  describe '.edit_group_board_list' do
    before do
      stub_put('/groups/5/boards/1/lists/1', 'group_board_list')
      @group_board_list = Gitlab.edit_group_board_list(5, 1, 1, position: 1)
    end

    it 'gets the correct resource' do
      expect(a_put('/groups/5/boards/1/lists/1')
        .with(body: { position: 1 })).to have_been_made
    end

    it 'returns information about an edited group issue board list' do
      expect(@group_board_list.position).to eq(1)
    end
  end

  describe '.delete_group_board_list' do
    before do
      stub_delete('/groups/5/boards/1/lists/1', 'empty')
      Gitlab.delete_group_board_list(5, 1, 1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/groups/5/boards/1/lists/1')).to have_been_made
    end
  end
end
