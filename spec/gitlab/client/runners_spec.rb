require 'spec_helper'

describe Gitlab::Client do

  describe ".runners" do
    before do
      stub_get("/runners", "runners")
    end

    context 'without scope' do
      before do
        @runner = Gitlab.runners
      end

      it "gets the correct resource" do
        expect(a_get("/runners")).to have_been_made
      end

      it "returns a paginated response of runners" do
        expect(@runner).to be_a Gitlab::PaginatedResponse
        expect(@runner.first.id).to eq(6)
        expect(@runner.first.description).to eq('test-1-20150125')
      end
    end

    context 'with scope' do
      before do
        stub_get("/runners?scope=online", "runners")
        @runner = Gitlab.runners({scope: :online})
      end

      it "gets the correct resource" do
        expect(a_get("/runners").with(query: { scope: :online })).to have_been_made
      end

      it "returns a paginated response of runners" do
        expect(@runner).to be_a Gitlab::PaginatedResponse
        expect(@runner.first.id).to eq(6)
        expect(@runner.first.description).to eq('test-1-20150125')
      end
    end

  end

  describe ".all_runners" do
    before do
      stub_get("/runners/all", "runners")
    end

    context 'without scope' do
      before do
        @runner = Gitlab.all_runners
      end

      it "gets the correct resource" do
        expect(a_get("/runners/all")).to have_been_made
      end

      it "returns a paginated response of runners" do
        expect(@runner).to be_a Gitlab::PaginatedResponse
        expect(@runner.first.id).to eq(6)
        expect(@runner.first.description).to eq('test-1-20150125')
      end
    end

    context 'with scope' do
      before do
        stub_get("/runners/all?scope=online", "runners")
        @runner = Gitlab.all_runners({scope: :online})
      end

      it "gets the correct resource" do
        expect(a_get("/runners/all").with(query: { scope: :online })).to have_been_made
      end

      it "returns a paginated response of runners" do
        expect(@runner).to be_a Gitlab::PaginatedResponse
        expect(@runner.first.id).to eq(6)
        expect(@runner.first.description).to eq('test-1-20150125')
      end
    end
  end

  describe ".runner" do
    before do
      stub_get("/runners/6", "runner")
      @runners = Gitlab.runner(6)
    end

    it "gets the correct resource" do
      expect(a_get("/runners/6")).to have_been_made
    end

    it "returns a response of a runner" do
      expect(@runners).to be_a Gitlab::ObjectifiedHash
      expect(@runners.id).to eq(6)
      expect(@runners.description).to eq('test-1-20150125')
    end
  end

  describe ".update_runner" do
    before do
      stub_put("/runners/6", "runner_edit").with(query: { description: "abcefg" })
      @runner = Gitlab.update_runner(6, description: "abcefg" )
    end

    it "gets the correct resource" do
      expect(a_put("/runners/6").with(query: { description: "abcefg" })).to have_been_made
    end

    it "returns an updated response of a runner" do
      expect(@runner).to be_a Gitlab::ObjectifiedHash
      expect(@runner.description).to eq('abcefg')
    end
  end

  describe ".delete_runner" do
    before do
      stub_delete("/runners/6", "runner_delete")
      @runner = Gitlab.delete_runner(6)
    end

    it "gets the correct resource" do
      expect(a_delete("/runners/6")).to have_been_made
    end

    it "returns a response of the deleted runner" do
      expect(@runner).to be_a Gitlab::ObjectifiedHash
      expect(@runner.id).to eq(6)
    end
  end

  describe ".project_runners" do
    before do
      stub_get("/projects/1/runners", "project_runners")
      @runners = Gitlab.project_runners(1)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/1/runners")).to have_been_made
    end

    it "returns a paginated response of runners" do
      expect(@runners).to be_a Gitlab::PaginatedResponse
      expect(@runners.first.id).to eq(8)
      expect(@runners.first.description).to eq('test-2-20150125')
    end
  end

  describe ".project_enable_runner" do
    before do
      stub_post("/projects/1/runners", "runner")
      @runner = Gitlab.project_enable_runner(1, 6)
    end

    it "gets the correct resource" do
      expect(a_post("/projects/1/runners")).to have_been_made
    end

    it "returns a response of the enabled runner" do
      expect(@runner).to be_a Gitlab::ObjectifiedHash
      expect(@runner.id).to eq(6)
      expect(@runner.description).to eq('test-1-20150125')
    end
  end

  describe ".project_disable_runner" do
    before do
      stub_delete("/projects/1/runners/6", "runner")
      @runner = Gitlab.project_disable_runner(1, 6)
    end

    it "gets the correct resource" do
      expect(a_delete("/projects/1/runners/6")).to have_been_made
    end

    it "returns a response of the disabled runner" do
      expect(@runner).to be_a Gitlab::ObjectifiedHash
      expect(@runner.id).to eq(6)
      expect(@runner.description).to eq('test-1-20150125')
    end
  end
end
