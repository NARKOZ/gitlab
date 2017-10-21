require 'spec_helper'

describe Gitlab::Client do
  describe '.award_emojis' do
    context 'when issue award emojis' do
      before do
        stub_get("/projects/1/issues/80/award_emoji", "issue_award_emojis")
        @emojis = Gitlab.award_emojis(1, 80, 'issue')
      end

      it "gets the correct resources" do
        expect(a_get("/projects/1/issues/80/award_emoji")).to have_been_made
      end

      it "returns a paginated response of issue award emojis" do
        expect(@emojis).to be_a Gitlab::PaginatedResponse
        expect(@emojis.first.awardable_id).to eq(80)
        expect(@emojis.first.awardable_type).to eq("Issue")
      end
    end

    context 'when merge request award emojis' do
      before do
        stub_get("/projects/1/merge_requests/80/award_emoji", "merge_request_award_emojis")
        @emojis = Gitlab.award_emojis(1, 80, 'merge_request')
      end

      it "gets the correct resources" do
        expect(a_get("/projects/1/merge_requests/80/award_emoji")).to have_been_made
      end

      it "returns a paginated response of merge request award emojis" do
        expect(@emojis).to be_a Gitlab::PaginatedResponse
        expect(@emojis.first.awardable_id).to eq(80)
        expect(@emojis.first.awardable_type).to eq("MergeRequest")
      end
    end

    context 'when snippet award emojis' do
      before do
        stub_get("/projects/1/snippets/80/award_emoji", "snippet_award_emojis")
        @emojis = Gitlab.award_emojis(1, 80, 'snippet')
      end

      it "gets the correct resources" do
        expect(a_get("/projects/1/snippets/80/award_emoji")).to have_been_made
      end

      it "returns a paginated response of snippet award emojis" do
        expect(@emojis).to be_a Gitlab::PaginatedResponse
        expect(@emojis.first.awardable_id).to eq(80)
        expect(@emojis.first.awardable_type).to eq("Snippet")
      end
    end
  end

  describe '.note_award_emojis' do
    context 'when issue note award emojis' do
      before do
        stub_get("/projects/1/issues/80/notes/1/award_emoji", "note_award_emojis")
        @note_emojis = Gitlab.note_award_emojis(1, 80, 'issue', 1)
      end

      it "gets the correct resources" do
        expect(a_get("/projects/1/issues/80/notes/1/award_emoji")).to have_been_made
      end

      it "returns a paginated response of issue note award emojis" do
        expect(@note_emojis).to be_a Gitlab::PaginatedResponse
        expect(@note_emojis.first.awardable_id).to eq(1)
        expect(@note_emojis.first.awardable_type).to eq("Note")
      end
    end

    context 'when merge request note award emojis' do
      before do
        stub_get("/projects/1/merge_requests/80/notes/1/award_emoji", "note_award_emojis")
        @note_emojis = Gitlab.note_award_emojis(1, 80, 'merge_request', 1)
      end

      it "gets the correct resources" do
        expect(a_get("/projects/1/merge_requests/80/notes/1/award_emoji")).to have_been_made
      end

      it "returns a paginated response of merge request note award emojis" do
        expect(@note_emojis).to be_a Gitlab::PaginatedResponse
        expect(@note_emojis.first.awardable_id).to eq(1)
        expect(@note_emojis.first.awardable_type).to eq("Note")
      end
    end

    context 'when snippet note award emojis' do
      before do
        stub_get("/projects/1/snippets/80/notes/1/award_emoji", "note_award_emojis")
        @note_emojis = Gitlab.note_award_emojis(1, 80, 'snippet', 1)
      end

      it "gets the correct resources" do
        expect(a_get("/projects/1/snippets/80/notes/1/award_emoji")).to have_been_made
      end

      it "returns a paginated response of snippet note award emojis" do
        expect(@note_emojis).to be_a Gitlab::PaginatedResponse
        expect(@note_emojis.first.awardable_id).to eq(1)
        expect(@note_emojis.first.awardable_type).to eq("Note")
      end
    end
  end

  describe '.award_emoji' do
    context 'when issue award emoji' do
      before do
        stub_get("/projects/1/issues/80/award_emoji/4", "issue_award_emoji")
        @emoji = Gitlab.award_emoji(1, 80, 'issue', 4)
      end

      it "gets the correct resource" do
        expect(a_get("/projects/1/issues/80/award_emoji/4")).to have_been_made
      end

      it "returns information about an issue award emoji" do
        expect(@emoji.id).to eq(4)
        expect(@emoji.awardable_type).to eq("Issue")
        expect(@emoji.awardable_id).to eq(80)
      end
    end

    context 'when merge request award emoji' do
      before do
        stub_get("/projects/1/merge_requests/80/award_emoji/4", "merge_request_award_emoji")
        @emoji = Gitlab.award_emoji(1, 80, 'merge_request', 4)
      end

      it "gets the correct resource" do
        expect(a_get("/projects/1/merge_requests/80/award_emoji/4")).to have_been_made
      end

      it "returns information about a merge request award emoji" do
        expect(@emoji.id).to eq(4)
        expect(@emoji.awardable_type).to eq("MergeRequest")
        expect(@emoji.awardable_id).to eq(80)
      end
    end

    context 'when snippet award emoji' do
      before do
        stub_get("/projects/1/snippets/80/award_emoji/4", "snippet_award_emoji")
        @emoji = Gitlab.award_emoji(1, 80, 'snippet', 4)
      end

      it "gets the correct resource" do
        expect(a_get("/projects/1/snippets/80/award_emoji/4")).to have_been_made
      end

      it "returns information about a snippet award emoji" do
        expect(@emoji.id).to eq(4)
        expect(@emoji.awardable_type).to eq("Snippet")
        expect(@emoji.awardable_id).to eq(80)
      end
    end
  end

  describe '.note_award_emoji' do
    context 'when issue note award emoji' do
      before do
        stub_get("/projects/1/issues/80/notes/1/award_emoji/4", "note_award_emoji")
        @note_emoji = Gitlab.note_award_emoji(1, 80, 'issue', 1, 4)
      end

      it "gets the correct resource" do
        expect(a_get("/projects/1/issues/80/notes/1/award_emoji/4")).to have_been_made
      end

      it "returns information about an issue note award emoji" do
        expect(@note_emoji.id).to eq(4)
        expect(@note_emoji.awardable_type).to eq("Note")
        expect(@note_emoji.awardable_id).to eq(1)
      end
    end

    context 'when merge request note award emoji' do
      before do
        stub_get("/projects/1/merge_requests/80/notes/1/award_emoji/4", "note_award_emoji")
        @note_emoji = Gitlab.note_award_emoji(1, 80, 'merge_request', 1, 4)
      end

      it "gets the correct resource" do
        expect(a_get("/projects/1/merge_requests/80/notes/1/award_emoji/4")).to have_been_made
      end

      it "returns information about a merge request note award emoji" do
        expect(@note_emoji.id).to eq(4)
        expect(@note_emoji.awardable_type).to eq("Note")
        expect(@note_emoji.awardable_id).to eq(1)
      end
    end

    context 'when snippet note award emoji' do
      before do
        stub_get("/projects/1/snippets/80/notes/1/award_emoji/4", "note_award_emoji")
        @note_emoji = Gitlab.note_award_emoji(1, 80, 'snippet', 1, 4)
      end

      it "gets the correct resource" do
        expect(a_get("/projects/1/snippets/80/notes/1/award_emoji/4")).to have_been_made
      end

      it "returns information about a snippet note award emoji" do
        expect(@note_emoji.id).to eq(4)
        expect(@note_emoji.awardable_type).to eq("Note")
        expect(@note_emoji.awardable_id).to eq(1)
      end
    end
  end

  describe '.create_award_emoji' do
    context 'when issue award emoji' do
      before do
        stub_post("/projects/1/issues/80/award_emoji", "issue_award_emoji")
        @emoji = Gitlab.create_award_emoji(1, 80, "issue", "blowfish")
      end

      it "gets the correct resource" do
        expect(a_post("/projects/1/issues/80/award_emoji").
          with(body: { name: 'blowfish' })).to have_been_made
      end

      it "returns correct information about the created issue award emoji" do
        expect(@emoji.name).to eq('blowfish')
        expect(@emoji.awardable_type).to eq('Issue')
      end
    end

    context 'when merge request award emoji' do
      before do
        stub_post("/projects/1/merge_requests/80/award_emoji", "merge_request_award_emoji")
        @emoji = Gitlab.create_award_emoji(1, 80, "merge_request", "blowfish")
      end

      it "gets the correct resource" do
        expect(a_post("/projects/1/merge_requests/80/award_emoji").
          with(body: { name: 'blowfish' })).to have_been_made
      end

      it "returns correct information about the created merge request award emoji" do
        expect(@emoji.name).to eq('blowfish')
        expect(@emoji.awardable_type).to eq('MergeRequest')
      end
    end

    context 'when snippet award emoji' do
      before do
        stub_post("/projects/1/snippets/80/award_emoji", "snippet_award_emoji")
        @emoji = Gitlab.create_award_emoji(1, 80, "snippet", "blowfish")
      end

      it "gets the correct resource" do
        expect(a_post("/projects/1/snippets/80/award_emoji").
          with(body: { name: 'blowfish' })).to have_been_made
      end

      it "returns correct information about the created snippet award emoji" do
        expect(@emoji.name).to eq('blowfish')
        expect(@emoji.awardable_type).to eq('Snippet')
      end
    end
  end

  describe '.create_note_award_emoji' do
    context 'when issue note award emoji' do
      before do
        stub_post("/projects/1/issues/80/notes/1/award_emoji", "note_award_emoji")
        @note_emoji = Gitlab.create_note_award_emoji(1, 80, "issue", 1, "mood_bubble_lightning")
      end

      it "gets the correct resource" do
        expect(a_post("/projects/1/issues/80/notes/1/award_emoji").
          with(body: { name: 'mood_bubble_lightning' })).to have_been_made
      end

      it "returns correct information about the created issue note award emoji" do
        expect(@note_emoji.name).to eq('mood_bubble_lightning')
        expect(@note_emoji.awardable_type).to eq('Note')
      end
    end

    context 'when merge request note award emoji' do
      before do
        stub_post("/projects/1/merge_requests/80/notes/1/award_emoji", "note_award_emoji")
        @note_emoji = Gitlab.create_note_award_emoji(1, 80, "merge_request", 1, "mood_bubble_lightning")
      end

      it "gets the correct resource" do
        expect(a_post("/projects/1/merge_requests/80/notes/1/award_emoji").
          with(body: { name: 'mood_bubble_lightning' })).to have_been_made
      end

      it "returns correct information about the created merge request note award emoji" do
        expect(@note_emoji.name).to eq('mood_bubble_lightning')
        expect(@note_emoji.awardable_type).to eq('Note')
      end
    end

    context 'when snippet note award emoji' do
      before do
        stub_post("/projects/1/snippets/80/notes/1/award_emoji", "note_award_emoji")
        @note_emoji = Gitlab.create_note_award_emoji(1, 80, "snippet", 1, "mood_bubble_lightning")
      end

      it "gets the correct resource" do
        expect(a_post("/projects/1/snippets/80/notes/1/award_emoji").
          with(body: { name: 'mood_bubble_lightning' })).to have_been_made
      end

      it "returns correct information about the created snippet note award emoji" do
        expect(@note_emoji.name).to eq('mood_bubble_lightning')
        expect(@note_emoji.awardable_type).to eq('Note')
      end
    end
  end

  describe '.delete_award_emoji' do
    context 'when issue award emoji' do
      before do
        stub_delete("/projects/1/issues/80/award_emoji/4", "issue_award_emoji")
        @emoji = Gitlab.delete_award_emoji(1, 80, "issue", 4)
      end

      it "gets the correct resource" do
        expect(a_delete("/projects/1/issues/80/award_emoji/4")).to have_been_made
      end
    end

    context 'when merge request award emoji' do
      before do
        stub_delete("/projects/1/merge_requests/80/award_emoji/4", "merge_request_award_emoji")
        @emoji = Gitlab.delete_award_emoji(1, 80, "merge_request", 4)
      end

      it "gets the correct resource" do
        expect(a_delete("/projects/1/merge_requests/80/award_emoji/4")).to have_been_made
      end
    end

    context 'when snippet award emoji' do
      before do
        stub_delete("/projects/1/snippets/80/award_emoji/4", "snippet_award_emoji")
        @emoji = Gitlab.delete_award_emoji(1, 80, "snippet", 4)
      end

      it "gets the correct resource" do
        expect(a_delete("/projects/1/snippets/80/award_emoji/4")).to have_been_made
      end
    end
  end

  describe '.delete_note_award_emoji' do
    context 'when issue note award emoji' do
      before do
        stub_delete("/projects/1/issues/80/notes/1/award_emoji/4", "note_award_emoji")
        @note_emoji = Gitlab.delete_note_award_emoji(1, 80, "issue", 1, 4)
      end

      it "gets the correct resource" do
        expect(a_delete("/projects/1/issues/80/notes/1/award_emoji/4")).to have_been_made
      end
    end

    context 'when merge request note award emoji' do
      before do
        stub_delete("/projects/1/merge_requests/80/notes/1/award_emoji/4", "note_award_emoji")
        @note_emoji = Gitlab.delete_note_award_emoji(1, 80, "merge_request", 1, 4)
      end

      it "gets the correct resource" do
        expect(a_delete("/projects/1/merge_requests/80/notes/1/award_emoji/4")).to have_been_made
      end
    end

    context 'when snippet note award emoji' do
      before do
        stub_delete("/projects/1/snippets/80/notes/1/award_emoji/4", "note_award_emoji")
        @note_emoji = Gitlab.delete_note_award_emoji(1, 80, "snippet", 1, 4)
      end

      it "gets the correct resource" do
        expect(a_delete("/projects/1/snippets/80/notes/1/award_emoji/4")).to have_been_made
      end
    end
  end
end
