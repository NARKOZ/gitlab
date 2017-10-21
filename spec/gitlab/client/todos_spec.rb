require 'spec_helper'

describe Gitlab::Client do
  describe '.todos' do
    before do
      stub_get("/todos", "todos")
      @todos = Gitlab.todos
    end

    it "gets the correct resources" do
      expect(a_get("/todos")).to have_been_made
    end

    it "returns a paginated response of user's todos" do
      expect(@todos).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.mark_todo_as_done' do
    before do
      stub_post("/todos/102/mark_as_done", "todo")
      @todo = Gitlab.mark_todo_as_done(102)
    end

    it "gets the correct resource" do
      expect(a_post("/todos/102/mark_as_done")).to have_been_made
    end

    it "returns information about the todo marked as done" do
      expect(@todo.id).to eq(102)
      expect(@todo.state).to eq('done')
    end
  end

  describe '.mark_all_todos_as_done' do
    before do
      stub_post("/todos/mark_as_done", "todos")
      @todos = Gitlab.mark_all_todos_as_done
    end

    it "gets the correct resources" do
      expect(a_post("/todos/mark_as_done")).to have_been_made
    end
  end
end
