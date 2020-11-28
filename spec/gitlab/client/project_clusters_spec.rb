# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.project_clusters' do
    before do
      stub_get('/projects/3/clusters', 'project_clusters')
      @project_clusters = Gitlab.project_clusters(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/clusters')).to have_been_made
    end

    it "returns a paginated response of project's clusters" do
      expect(@project_clusters).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.project_cluster' do
    before do
      stub_get('/projects/3/clusters/18', 'project_cluster')
      @project_cluster = Gitlab.project_cluster(3, 18)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/clusters/18')).to have_been_made
    end

    it 'returns information about a cluster' do
      expect(@project_cluster.id).to eq(18)
    end
  end

  describe '.add_project_cluster' do
    before do
      stub_post('/projects/3/clusters/user', 'project_cluster')
      @project_cluster = Gitlab.add_project_cluster(3, 'cluster-1', enabled: false, platform_kubernetes_attributes: { api_url: 'https://104.197.68.152', token: '12345', ca_cert: "-----BEGIN CERTIFICATE-----\r\nhFiK1L61owwDQYJKoZIhvcNAQELBQAw\r\nLzEtMCsGA1UEAxMkZDA1YzQ1YjctNzdiMS00NDY0LThjNmEtMTQ0ZDJkZjM4ZDBj\r\nMB4XDTE4MTIyNzIwMDM1MVoXDTIzMTIyNjIxMDM1MVowLzEtMCsGA1UEAxMkZDA1\r\nYzQ1YjctNzdiMS00NDY0LThjNmEtMTQ0ZDJkZjM.......-----END CERTIFICATE-----", namespace: 'cluster-1-namespace', authorization_type: 'rbac' })
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/clusters/user')
        .with(body: { name: 'cluster-1' }.merge(enabled: false, platform_kubernetes_attributes: { api_url: 'https://104.197.68.152', token: '12345', ca_cert: "-----BEGIN CERTIFICATE-----\r\nhFiK1L61owwDQYJKoZIhvcNAQELBQAw\r\nLzEtMCsGA1UEAxMkZDA1YzQ1YjctNzdiMS00NDY0LThjNmEtMTQ0ZDJkZjM4ZDBj\r\nMB4XDTE4MTIyNzIwMDM1MVoXDTIzMTIyNjIxMDM1MVowLzEtMCsGA1UEAxMkZDA1\r\nYzQ1YjctNzdiMS00NDY0LThjNmEtMTQ0ZDJkZjM.......-----END CERTIFICATE-----", namespace: 'cluster-1-namespace', authorization_type: 'rbac' }))).to have_been_made
    end

    it 'returns information about an added project cluster' do
      expect(@project_cluster.name).to eq('cluster-1')
      expect(@project_cluster.platform_kubernetes.api_url).to eq('https://104.197.68.152')
      expect(@project_cluster.platform_kubernetes.namespace).to eq('cluster-1-namespace')
      expect(@project_cluster.platform_kubernetes.authorization_type).to eq('rbac')
      expect(@project_cluster.platform_kubernetes.ca_cert).to eq("-----BEGIN CERTIFICATE-----\r\nhFiK1L61owwDQYJKoZIhvcNAQELBQAw\r\nLzEtMCsGA1UEAxMkZDA1YzQ1YjctNzdiMS00NDY0LThjNmEtMTQ0ZDJkZjM4ZDBj\r\nMB4XDTE4MTIyNzIwMDM1MVoXDTIzMTIyNjIxMDM1MVowLzEtMCsGA1UEAxMkZDA1\r\nYzQ1YjctNzdiMS00NDY0LThjNmEtMTQ0ZDJkZjM.......-----END CERTIFICATE-----")
    end
  end

  describe '.edit_project_cluster' do
    before do
      stub_put('/projects/3/clusters/18', 'project_cluster')
      @project_cluster = Gitlab.edit_project_cluster(3, 18, name: 'cluster-1', platform_kubernetes_attributes: { api_url: 'https://104.197.68.152' })
    end

    it 'gets the correct resource' do
      expect(a_put('/projects/3/clusters/18')
        .with(body: { name: 'cluster-1', platform_kubernetes_attributes: { api_url: 'https://104.197.68.152' } })).to have_been_made
    end

    it 'returns information about an edited project cluster' do
      expect(@project_cluster.name).to eq('cluster-1')
      expect(@project_cluster.platform_kubernetes.api_url).to eq('https://104.197.68.152')
    end
  end

  describe '.delete_project_cluster' do
    before do
      stub_delete('/projects/3/clusters/18', 'empty')
      Gitlab.delete_project_cluster(3, 18)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/3/clusters/18')).to have_been_made
    end
  end
end
