require 'spec_helper'

describe Gitlab::Client do
  describe "notes" do
    context "when wall notes" do
      before do
        stub_get("/projects/3/notes", "notes")
        @notes = Gitlab.notes(3)
      end

      it "gets the correct resource" do
        expect(a_get("/projects/3/notes")).to have_been_made
      end

      it "returns a paginated response of notes" do
        expect(@notes).to be_a Gitlab::PaginatedResponse
        expect(@notes.first.author.name).to eq("John Smith")
      end
    end

    context "when issue notes" do
      before do
        stub_get("/projects/3/issues/7/notes", "notes")
        @notes = Gitlab.issue_notes(3, 7)
      end

      it "gets the correct resource" do
        expect(a_get("/projects/3/issues/7/notes")).to have_been_made
      end

      it "returns a paginated response of notes" do
        expect(@notes).to be_a Gitlab::PaginatedResponse
        expect(@notes.first.author.name).to eq("John Smith")
      end
    end

    context "when snippet notes" do
      before do
        stub_get("/projects/3/snippets/7/notes", "notes")
        @notes = Gitlab.snippet_notes(3, 7)
      end

      it "gets the correct resource" do
        expect(a_get("/projects/3/snippets/7/notes")).to have_been_made
      end

      it "returns a paginated response of notes" do
        expect(@notes).to be_a Gitlab::PaginatedResponse
        expect(@notes.first.author.name).to eq("John Smith")
      end
    end

    context "when merge_request notes" do
      before do
        stub_get("/projects/3/merge_requests/7/notes", "notes")
        @notes = Gitlab.merge_request_notes(3, 7)
      end

      it "gets the correct resource" do
        expect(a_get("/projects/3/merge_requests/7/notes")).to have_been_made
      end

      it "returns a paginated response of notes" do
        expect(@notes).to be_a Gitlab::PaginatedResponse
        expect(@notes.first.author.name).to eq("John Smith")
      end
    end
  end

  describe "note" do
    context "when wall note" do
      before do
        stub_get("/projects/3/notes/1201", "note")
        @note = Gitlab.note(3, 1201)
      end

      it "gets the correct resource" do
        expect(a_get("/projects/3/notes/1201")).to have_been_made
      end

      it "returns information about a note" do
        expect(@note.body).to eq("The solution is rather tricky")
        expect(@note.author.name).to eq("John Smith")
      end
    end

    context "when issue note" do
      before do
        stub_get("/projects/3/issues/7/notes/1201", "note")
        @note = Gitlab.issue_note(3, 7, 1201)
      end

      it "gets the correct resource" do
        expect(a_get("/projects/3/issues/7/notes/1201")).to have_been_made
      end

      it "returns information about a note" do
        expect(@note.body).to eq("The solution is rather tricky")
        expect(@note.author.name).to eq("John Smith")
      end
    end

    context "when snippet note" do
      before do
        stub_get("/projects/3/snippets/7/notes/1201", "note")
        @note = Gitlab.snippet_note(3, 7, 1201)
      end

      it "gets the correct resource" do
        expect(a_get("/projects/3/snippets/7/notes/1201")).to have_been_made
      end

      it "returns information about a note" do
        expect(@note.body).to eq("The solution is rather tricky")
        expect(@note.author.name).to eq("John Smith")
      end
    end

    context "when merge request note" do
      before do
        stub_get("/projects/3/merge_requests/7/notes/1201", "note")
        @note = Gitlab.merge_request_note(3, 7, 1201)
      end

      it "gets the correct resource" do
        expect(a_get("/projects/3/merge_requests/7/notes/1201")).to have_been_made
      end

      it "returns information about a note" do
        expect(@note.body).to eq("The solution is rather tricky")
        expect(@note.author.name).to eq("John Smith")
      end
    end
  end

  describe "create note" do
    context "when wall note" do
      before do
        stub_post("/projects/3/notes", "note")
        @note = Gitlab.create_note(3, "The solution is rather tricky")
      end

      it "gets the correct resource" do
        expect(a_post("/projects/3/notes").
          with(body: { body: 'The solution is rather tricky' })).to have_been_made
      end

      it "returns information about a created note" do
        expect(@note.body).to eq("The solution is rather tricky")
        expect(@note.author.name).to eq("John Smith")
      end
    end

    context "when issue note" do
      before do
        stub_post("/projects/3/issues/7/notes", "note")
        @note = Gitlab.create_issue_note(3, 7, "The solution is rather tricky")
      end

      it "gets the correct resource" do
        expect(a_post("/projects/3/issues/7/notes").
          with(body: { body: 'The solution is rather tricky' })).to have_been_made
      end

      it "returns information about a created note" do
        expect(@note.body).to eq("The solution is rather tricky")
        expect(@note.author.name).to eq("John Smith")
      end
    end

    context "when snippet note" do
      before do
        stub_post("/projects/3/snippets/7/notes", "note")
        @note = Gitlab.create_snippet_note(3, 7, "The solution is rather tricky")
      end

      it "gets the correct resource" do
        expect(a_post("/projects/3/snippets/7/notes").
          with(body: { body: 'The solution is rather tricky' })).to have_been_made
      end

      it "returns information about a created note" do
        expect(@note.body).to eq("The solution is rather tricky")
        expect(@note.author.name).to eq("John Smith")
      end
    end

    context "when merge_request note" do
      before do
        stub_post("/projects/3/merge_requests/7/notes", "note")
        @note = Gitlab.create_merge_request_note(3, 7, "The solution is rather tricky")
      end

      it "gets the correct resource" do
        expect(a_post("/projects/3/merge_requests/7/notes").
          with(body: { body: 'The solution is rather tricky' })).to have_been_made
      end

      it "returns information about a created note" do
        expect(@note.body).to eq("The solution is rather tricky")
        expect(@note.author.name).to eq("John Smith")
      end
    end
  end

  describe "delete note" do
    context "when wall note" do
      before do
        stub_delete("/projects/3/notes/1201", "note")
        @note = Gitlab.delete_note(3, 1201)
      end

      it "gets the correct resource" do
        expect(a_delete("/projects/3/notes/1201")).to have_been_made
      end

      it "returns information about a deleted note" do
        expect(@note.id).to eq(1201)
      end
    end

    context "when issue note" do
      before do
        stub_delete("/projects/3/issues/7/notes/1201", "note")
        @note = Gitlab.delete_issue_note(3, 7, 1201)
      end

      it "gets the correct resource" do
        expect(a_delete("/projects/3/issues/7/notes/1201")).to have_been_made
      end

      it "returns information about a deleted issue note" do
        expect(@note.id).to eq(1201)
      end
    end

    context "when snippet note" do
      before do
        stub_delete("/projects/3/snippets/7/notes/1201", "note")
        @note = Gitlab.delete_snippet_note(3, 7, 1201)
      end

      it "gets the correct resource" do
        expect(a_delete("/projects/3/snippets/7/notes/1201")).to have_been_made
      end

      it "returns information about a deleted snippet note" do
        expect(@note.id).to eq(1201)
      end
    end

    context "when merge request note" do
      before do
        stub_delete("/projects/3/merge_requests/7/notes/1201", "note")
        @note = Gitlab.delete_merge_request_note(3, 7, 1201)
      end

      it "gets the correct resource" do
        expect(a_delete("/projects/3/merge_requests/7/notes/1201")).to have_been_made
      end

      it "returns information about a deleted merge request note" do
        expect(@note.id).to eq(1201)
      end
    end
  end

  describe "modify note" do
    context "when wall note" do
      before do
        stub_put("/projects/3/notes/1201", "note")
        @note = Gitlab.edit_note(3, 1201, body: "edited wall note content")
      end

      it "gets the correct resource" do
        expect(a_put("/projects/3/notes/1201").
          with(body: {body: 'edited wall note content'})).to have_been_made
      end

      it "returns information about a modified note" do
        expect(@note.id).to eq(1201)
      end
    end

    context "when issue note" do
      before do
        stub_put("/projects/3/issues/7/notes/1201", "note")
        @note = Gitlab.edit_issue_note(3, 7, 1201, body: "edited issue note content")
      end

      it "gets the correct resource" do
        expect(a_put("/projects/3/issues/7/notes/1201").
          with(body: {body: 'edited issue note content'})).to have_been_made
      end

      it "returns information about a modified issue note" do
        expect(@note.id).to eq(1201)
      end
    end

    context "when snippet note" do
      before do
        stub_put("/projects/3/snippets/7/notes/1201", "note")
        @note = Gitlab.edit_snippet_note(3, 7, 1201, body: "edited snippet note content")
      end

      it "gets the correct resource" do
        expect(a_put("/projects/3/snippets/7/notes/1201").
          with(body: {body: 'edited snippet note content'})).to have_been_made
      end

      it "returns information about a modified snippet note" do
        expect(@note.id).to eq(1201)
      end
    end

    context "when merge request note" do
      before do
        stub_put("/projects/3/merge_requests/7/notes/1201", "note")
        @note = Gitlab.edit_merge_request_note(3, 7, 1201, body: "edited merge request note content")
      end

      it "gets the correct resource" do
        expect(a_put("/projects/3/merge_requests/7/notes/1201").
          with(body: {body: 'edited merge request note content'})).to have_been_made
      end

      it "returns information about a modified request note" do
        expect(@note.id).to eq(1201)
      end
    end
  end
end
