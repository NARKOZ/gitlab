require 'spec_helper'

describe Gitlab::Client do
  describe ".variables" do
    before do
      stub_get("/projects/3/variables", "variables")
      @variables = Gitlab.variables(3)
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/variables")).to have_been_made
    end

    it "should return an array of project's variables" do
      expect(@variables).to be_a Gitlab::PaginatedResponse
      expect(@variables.first.key).to eq("TEST_VARIABLE_1")
      expect(@variables.first.value).to eq("TEST_1")
    end
  end

  describe ".variable" do
    before do
      stub_get("/projects/3/variables/VARIABLE", "variable")
      @variable = Gitlab.variable(3, "VARIABLE")
    end

    it "should get the correct resource" do
      expect(a_get("/projects/3/variables/VARIABLE")).to have_been_made
    end

    it "should return information about a variable" do
      expect(@variable.key).to eq("VARIABLE")
      expect(@variable.value).to eq("the value")
    end
  end

  describe ".create_variable" do
    before do
      stub_post("/projects/3/variables", "variable")
      @variable = Gitlab.create_variable(3, "NEW_VARIABLE", "new value")
    end

    it "should get the correct resource" do
      body = { key: "NEW_VARIABLE", value: "new value" }
      expect(a_post("/projects/3/variables").with(body: body)).to have_been_made
    end

    it "should return information about a new variable" do
      expect(@variable.key).to eq("VARIABLE")
      expect(@variable.value).to eq("the value")
    end
  end

  describe ".update_variable" do
    before do
      stub_put("/projects/3/variables/UPD_VARIABLE", "variable")
      @variable = Gitlab.update_variable(3, "UPD_VARIABLE", "updated value")
    end

    it "should put the correct resource" do
      body = { value: "updated value" }
      expect(a_put("/projects/3/variables/UPD_VARIABLE").with(body: body)).to have_been_made
    end

    it "should return information about an updated variable" do
      expect(@variable.key).to eq("VARIABLE")
      expect(@variable.value).to eq("the value")
    end
  end

  describe ".remove_variable" do
    before do
      stub_delete("/projects/3/variables/DEL_VARIABLE", "variable")
      @variable = Gitlab.remove_variable(3, "DEL_VARIABLE")
    end

    it "should get the correct resource" do
      expect(a_delete("/projects/3/variables/DEL_VARIABLE")).to have_been_made
    end

    it "should return information about a deleted variable" do
      expect(@variable.key).to eq("VARIABLE")
      expect(@variable.value).to eq("the value")
    end
  end
end
