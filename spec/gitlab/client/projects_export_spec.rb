# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.export_project' do
    before do
      stub_post('/projects/1/export', 'project_export')
      @export_project = Gitlab.export_project(1, { description: 'test_description-path', upload: { url: 'https://example.com/', http_method: 'POST' } })
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/1/export')
        .with(body: { description: 'test_description-path', upload: { url: 'https://example.com/', http_method: 'POST' } })).to have_been_made
    end

    it 'returns information about the project export request' do
      expect(@export_project.message).to eq('202 Accepted')
    end
  end

  describe '.project_export_status' do
    before do
      stub_get('/projects/1/export', 'project_export_status')
      @export_project = Gitlab.export_project_status(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/export')).to have_been_made
    end

    it 'returns information about the project export status' do
      expect(@export_project.export_status).to eq('none')
    end
  end

  describe '.exported_project_download' do
    context 'when successful request' do
      before do
        fixture = load_fixture('exported_project_download.tar.gz')
        fixture.set_encoding(Encoding::ASCII_8BIT)
        stub_request(:get, "#{Gitlab.endpoint}/projects/1/export/download")
          .with(headers: { 'PRIVATE-TOKEN' => Gitlab.private_token })
          .to_return(body: fixture.read, headers: { 'Content-Disposition' => 'attachment; filename=exported_project_download.tar.gz' })
        @exported_project = Gitlab.exported_project_download(1)
      end

      it 'gets the correct resource' do
        expect(a_get('/projects/1/export/download')).to have_been_made
      end

      it 'returns a FileResponse' do
        expect(@exported_project).to be_a Gitlab::FileResponse
      end

      it 'returns a file with filename' do
        expect(@exported_project.filename).to eq 'exported_project_download.tar.gz'
      end
    end

    context 'when bad request' do
      it 'throws an exception' do
        stub_get('/projects/1/export/download', 'error_project_not_found', 404)
        expect { Gitlab.exported_project_download(1) }.to raise_error(Gitlab::Error::NotFound, "Server responded with code 404, message: 404 Project Not Found. Request URI: #{Gitlab.endpoint}/projects/1/export/download")
      end
    end
  end
end
