require 'spec_helper'

describe Gitlab::CLI::Helpers do
  describe ".method_owners" do
    let(:methods) { Gitlab::CLI::Helpers.method_owners }

    it "returns Array of Hashes containing method names and owners" do
      expect(methods).to be_a Array
      expect(methods.all? { |m| m.is_a? Hash }).to be true
      expect(methods.all? { |m| m.keys.sort == %i(name owner) }).to be true
    end
  end

  describe ".valid_command?" do
    it "returns true when command is valid" do
      expect(Gitlab::CLI::Helpers.valid_command?('merge_requests')).to be_truthy
    end
    it "returns false when command is NOT valid" do
      expect(Gitlab::CLI::Helpers.valid_command?('mmmmmerge_requests')).to be_falsy
    end
  end

  describe ".symbolize_keys" do
    context "when input is a Hash" do
      it "returns a Hash with symbols for keys" do
        hash = { 'key1' => 'val1', 'key2' => 'val2' }
        symbolized_hash = Gitlab::CLI::Helpers.symbolize_keys(hash)
        expect(symbolized_hash).to eq(key1: 'val1', key2: 'val2')
      end
    end
    context "when input is NOT a Hash" do
      it "returns input untouched" do
        array = [1, 2, 3]
        new_array = Gitlab::CLI::Helpers.symbolize_keys(array)
        expect(new_array).to eq([1, 2, 3])
      end
    end
  end

  describe ".yaml_load" do
    context "when argument is a YAML string" do
      it "returns Ruby objects" do
        argument = "{foo: bar, sna: fu}"
        output = Gitlab::CLI::Helpers.yaml_load argument
        expect(output).to eq('foo' => 'bar', 'sna' => 'fu')
      end
    end

    context "when input is NOT valid YAML" do
      it "raises a TypeError" do
        ruby_array = [1, 2, 3, 4]
        expect { Gitlab::CLI::Helpers.yaml_load ruby_array }.to raise_error TypeError
      end
    end
  end
end
