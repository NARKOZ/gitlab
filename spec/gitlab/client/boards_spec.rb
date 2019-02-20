# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.boards' do
    before do
      stub_get('/projects/3/boards', 'boards')
      @boards = Gitlab.boards(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/boards')).to have_been_made
    end

    it "returns a paginated response of project's boards" do
      expect(@boards).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.board' do
    before do
      stub_get('/projects/5/boards/1', 'board')
      @board = Gitlab.board(5, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/5/boards/1')).to have_been_made
    end

    it 'returns information about the board' do
      expect(@board.id).to eq(1)
      expect(@board.project.id).to eq(5)
    end
  end

  describe '.create_board' do
    before do
      stub_post('/projects/5/boards', 'board')
      @board = Gitlab.create_board(5, 'project issue board')
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/5/boards')
        .with(body: { name: 'project issue board' })).to have_been_made
    end

    it 'returns information about a created board' do
      expect(@board.name).to eq('project issue board')
      expect(@board.project.id).to eq(5)
    end
  end

  describe '.edit_board' do
    before do
      stub_put('/projects/5/boards/1', 'updated_board')
      @board = Gitlab.edit_board(5, 1, name: 'new_name', milestone_id: 43, assignee_id: 1)
    end

    it 'gets the correct resource' do
      expect(a_put('/projects/5/boards/1')
        .with(body: { name: 'new_name', milestone_id: 43, assignee_id: 1 })).to have_been_made
    end

    it 'returns information about an edited board' do
      expect(@board.name).to eq('new_name')
      expect(@board.milestone.id).to eq(43)
      expect(@board.assignee.id).to eq(1)
    end
  end

  describe '.delete_board' do
    before do
      stub_delete('/projects/5/boards/1', 'empty')
      Gitlab.delete_board(5, 1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/5/boards/1')).to have_been_made
    end
  end

  describe '.board_lists' do
    before do
      stub_get('/projects/3/boards/1/lists', 'board_lists')
      @board_lists = Gitlab.board_lists(3, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/boards/1/lists')).to have_been_made
    end

    it "returns a paginated response of board's lists" do
      expect(@board_lists).to be_a Gitlab::PaginatedResponse
      expect(@board_lists.first.id).to eq(1)
    end
  end

  describe '.board_list' do
    before do
      stub_get('/projects/3/boards/1/lists/1', 'board_list')
      @board_list = Gitlab.board_list(3, 1, 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/boards/1/lists/1')).to have_been_made
    end

    it 'returns information about the list' do
      expect(@board_list.id).to eq(1)
    end
  end

  describe '.create_board_list' do
    before do
      stub_post('/projects/3/boards/1/lists', 'board_list')
      @board_list = Gitlab.create_board_list(3, 1, 4)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/boards/1/lists')).to have_been_made
    end

    it 'returns information about a created board list' do
      expect(@board_list.position).to eq(1)
    end
  end

  describe '.edit_board_list' do
    before do
      stub_put('/projects/3/boards/1/lists/1', 'board_list')
      @board_list = Gitlab.edit_board_list(3, 1, 1, 3)
    end

    it 'gets the correct resource' do
      expect(a_put('/projects/3/boards/1/lists/1')).to have_been_made
    end

    it 'returns information about an edited board list' do
      expect(@board_list.id).to eq(1)
    end
  end

  describe '.delete_board_list' do
    before do
      stub_delete('/projects/3/boards/1/lists/1', 'board_list')
      @board_list = Gitlab.delete_board_list(3, 1, 1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/3/boards/1/lists/1')).to have_been_made
    end

    it 'returns information about the deleted board list' do
      expect(@board_list.id).to eq(1)
    end
  end
end
