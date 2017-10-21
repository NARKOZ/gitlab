require 'spec_helper'

describe Gitlab::Client do
  it { is_expected.to respond_to :delete_trigger }

  describe ".triggers" do
    before do
      stub_get("/projects/3/triggers", "triggers")
      @triggers = Gitlab.triggers(3)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/triggers")).to have_been_made
    end

    it "returns an array of project's triggers" do
      expect(@triggers).to be_a Gitlab::PaginatedResponse
      expect(@triggers.first.token).to eq("6d056f63e50fe6f8c5f8f4aa10edb7")
    end
  end

  describe ".trigger" do
    before do
      stub_get("/projects/3/triggers/10", "trigger")
      @trigger = Gitlab.trigger(3, 10)
    end

    it "gets the correct resource" do
      expect(a_get("/projects/3/triggers/10")).to have_been_made
    end

    it "returns information about a trigger" do
      expect(@trigger.created_at).to eq("2016-01-07T09:53:58.235Z")
      expect(@trigger.token).to eq("6d056f63e50fe6f8c5f8f4aa10edb7")
    end
  end

  describe ".create_trigger" do
    before do
      stub_post("/projects/3/triggers", "trigger")
      @trigger = Gitlab.create_trigger(3, "my description")
    end

    it "gets the correct resource" do
      expect(a_post("/projects/3/triggers").
          with(body: { description: "my description" })).to have_been_made
    end

    it "returns information about a new trigger" do
      expect(@trigger.created_at).to eq("2016-01-07T09:53:58.235Z")
      expect(@trigger.token).to eq("6d056f63e50fe6f8c5f8f4aa10edb7")
    end
  end

  describe ".update_trigger" do
    before do
      stub_put("/projects/3/triggers/1", "trigger")
      @trigger = Gitlab.update_trigger(3, 1, description: "my description")
    end

    it "gets the correct resource" do
      expect(a_put("/projects/3/triggers/1").
          with(body: { description: "my description" })).to have_been_made
    end

    it "returns information about the trigger" do
      expect(@trigger.created_at).to eq("2016-01-07T09:53:58.235Z")
      expect(@trigger.token).to eq("6d056f63e50fe6f8c5f8f4aa10edb7")
    end
  end

  describe ".trigger_take_ownership" do
    before do
      stub_post("/projects/3/triggers/1/take_ownership", "trigger")
      @trigger = Gitlab.trigger_take_ownership(3, 1)
    end

    it "gets the correct resource" do
      expect(a_post("/projects/3/triggers/1/take_ownership")).to have_been_made
    end

    it "returns information about the trigger" do
      expect(@trigger.created_at).to eq("2016-01-07T09:53:58.235Z")
      expect(@trigger.token).to eq("6d056f63e50fe6f8c5f8f4aa10edb7")
    end
  end

  describe ".remove_trigger" do
    before do
      stub_delete("/projects/3/triggers/10", "empty")
      @trigger = Gitlab.remove_trigger(3, 10)
    end

    it "gets the correct resource" do
      expect(a_delete("/projects/3/triggers/10")).to have_been_made
    end
  end

  describe ".run_trigger" do
    before do
      stub_request(:post, "#{Gitlab.endpoint}/projects/3/trigger/pipeline").
        to_return(body: load_fixture("run_trigger"), status: 200)
    end

    context "when private_token is not set" do
      before do
        Gitlab.private_token = nil
      end

      it "does not raise Error::MissingCredentials" do
        expect { Gitlab.run_trigger(3, "7b9148c158980bbd9bcea92c17522d", "master", {a: 10}) }.to_not raise_error
      end

      after do
        Gitlab.private_token = 'secret'
      end
    end

    context "without variables" do
      before do
        @trigger = Gitlab.run_trigger(3, "7b9148c158980bbd9bcea92c17522d", "master")
      end

      it "gets the correct resource" do
        expect(a_request(:post, "#{Gitlab.endpoint}/projects/3/trigger/pipeline").
          with(body: {
            token: "7b9148c158980bbd9bcea92c17522d",
            ref: "master"
          })).to have_been_made
      end

      it "returns information about the triggered build" do
        expect(@trigger.id).to eq(8)
      end
    end

    context "with variables" do
      before do
        @trigger = Gitlab.run_trigger(3, "7b9148c158980bbd9bcea92c17522d", "master", {a: 10})
      end

      it "gets the correct resource" do
        expect(a_request(:post, "#{Gitlab.endpoint}/projects/3/trigger/pipeline").
          with(body: {
            token: "7b9148c158980bbd9bcea92c17522d",
            ref: "master",
            variables: {a: "10"}
          })).to have_been_made
      end

      it "returns information about the triggered build" do
        expect(@trigger.id).to eq(8)
        expect(@trigger.variables.a).to eq("10")
      end
    end
  end
end
