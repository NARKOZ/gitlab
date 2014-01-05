require 'spec_helper'

describe Gitlab::ObjectifiedHash do

  let(:remote_project) { JSON.parse(load_fixture('project').read) }

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
        subject { Gitlab::ObjectifiedHash.new(remote_project) }
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

  describe '.hash' do
    context 'when Gitlab::ObjectifiedHash is empty' do
      subject { Gitlab::ObjectifiedHash.new({}) }
      it 'should return an empty Hash' do
        subject.hash.should == {}
      end
    end
    context 'when Gitlab::ObjectifiedHash is not empty' do
      subject { Gitlab::ObjectifiedHash.new(remote_project) }
      it 'should return a Hash of a project' do
        subject.hash.should == {
          'id' => 3,
          'code' => 'gitlab',
          'name' => 'Gitlab',
          'description' => nil,
          'path' => 'gitlab',
          'default_branch' => nil,
          'owner' => {
            'id' => 1,
            'email' => 'john@example.com',
            'name' => 'John Smith',
            'blocked' => false,
            'created_at' => '2012-09-17T09:41:56Z'
          },
          'public' => false,
          'issues_enabled' => true,
          'merge_requests_enabled' => true,
          'wall_enabled' => true,
          'wiki_enabled' => true,
          'created_at' => '2012-09-17T09:41:58Z'
        }
      end
    end
  end

end
