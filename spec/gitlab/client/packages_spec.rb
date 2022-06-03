# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.project_packages' do
    before do
      stub_get('/projects/3/packages', 'project_packages')
      @packages = Gitlab.project_packages(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/packages')).to have_been_made
    end

    it "returns a paginated response of project's packages" do
      expect(@packages).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.group_packages' do
    before do
      stub_get('/groups/3/packages', 'group_packages')
      @packages = Gitlab.group_packages(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/3/packages')).to have_been_made
    end

    it "returns a paginated response of group's packages" do
      expect(@packages).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.project_package' do
    before do
      stub_get('/projects/3/packages/5', 'project_package')
      @package = Gitlab.project_package(3, 5)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/packages/5')).to have_been_made
    end

    it 'returns a single project package' do
      expect(@package).to be_a Gitlab::ObjectifiedHash
    end
  end

  describe '.project_package_files' do
    before do
      stub_get('/projects/3/packages/5/package_files', 'project_package_files')
      @package_files = Gitlab.project_package_files(3, 5)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/packages/5/package_files')).to have_been_made
    end

    it "returns a paginated response of package's files" do
      expect(@package_files).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.delete_project_package' do
    before do
      stub_delete('/projects/3/packages/13', 'project_package')
      Gitlab.delete_project_package(3, 13)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/3/packages/13')).to have_been_made
    end
  end

  describe '.delete_project_package_file' do
    before do
      stub_delete('/projects/3/packages/13/package_files/10', 'empty')
      Gitlab.delete_project_package_file(3, 13, 10)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/3/packages/13/package_files/10')).to have_been_made
    end
  end
end
