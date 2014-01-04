require 'spec_helper'

describe Gitlab::ObjectifiedHash do

  describe '.initialize' do
    context 'passing a nil' do
      it 'should raise error ArgumentError' do
        expect do
          Gitlab::ObjectifiedHash.new(nil)
        end.to raise_error(ArgumentError)
      end
    end
    context 'passing a String' do
      it 'should raise error ArgumentError' do
        expect do
          Gitlab::ObjectifiedHash.new('Gitlab')
        end.to raise_error(ArgumentError)
      end
    end
    context 'passing a Fixnum' do
      it 'should raise error ArgumentError' do
        expect do
          Gitlab::ObjectifiedHash.new(123)
        end.to raise_error(ArgumentError)
      end
    end
    context 'passing a Hash' do
      context 'empty' do
        subject { Gitlab::ObjectifiedHash.new({}) }
        it '.id should return nil' do
          subject.id.should be_nil
        end
      end
      context 'of a project' do
        subject do
          projet_attributes = JSON.parse(load_fixture('project').read)
          Gitlab::ObjectifiedHash.new(projet_attributes)
        end
        it '.id should be 3' do
          subject.id.should == 3
        end
        it '.code should be "gitlab"' do
          subject.code.should == 'gitlab'
        end
        it '.owner should return a Gitlab::ObjectifiedHash instance' do
          subject.owner.is_a?(Gitlab::ObjectifiedHash).should be_true
        end
        it '.owner.name should return "John Smith"' do
          subject.owner.name.should == 'John Smith'
        end
      end
    end
  end

end
