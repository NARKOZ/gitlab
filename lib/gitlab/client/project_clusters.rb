# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to project clusters.
  # @see https://docs.gitlab.com/ce/api/project_clusters.html
  module ProjectClusters
    # Returns a list of project clusters.
    #
    # @example
    #   Gitlab.project_clusters(5)
    #
    # @param [Integer, String] project The ID or name of a project.
    # @return [Array<Gitlab::ObjectifiedHash>] List of all clusters of a project
    def project_clusters(project)
      get("/projects/#{url_encode project}/clusters")
    end

    # Gets a single project cluster.
    #
    # @example
    #   Gitlab.project_cluster(5, 42)
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [Integer] cluster_id  The ID of the cluster.
    # @return [Gitlab::ObjectifiedHash] Information about the requested cluster
    def project_cluster(project, cluster_id)
      get("/projects/#{url_encode project}/clusters/#{cluster_id}")
    end

    # Adds an existing Kubernetes cluster to the project.
    #
    # @example
    #   Gitlab.add_project_cluster(5, 'cluster-5', { enabled: false, platform_kubernetes_attributes: { api_url: 'https://35.111.51.20', token: '12345', ca_cert: "-----BEGIN CERTIFICATE-----\r\nhFiK1L61owwDQYJKoZIhvcNAQELBQAw\r\nLzEtMCsGA1UEAxMkZDA1YzQ1YjctNzdiMS00NDY0LThjNmEtMTQ0ZDJkZjM4ZDBj\r\nMB4XDTE4MTIyNzIwMDM1MVoXDTIzMTIyNjIxMDM1MVowLzEtMCsGA1UEAxMkZDA1\r\nYzQ1YjctNzdiMS00NDY0LThjNmEtMTQ0ZDJkZjM.......-----END CERTIFICATE-----", namespace: 'cluster-5-namespace', authorization_type: 'rbac' } })
    #   Gitlab.add_project_cluster(5, 'cluster-5', { platform_kubernetes_attributes: { api_url: 'https://35.111.51.20', token: '12345' } })
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [String] name  The name of the existing cluster.
    # @param  [Hash] options A customizable set of options.
    # @option options [Boolean] :enabled(optional)  Determines if cluster is active or not, defaults to true
    # @option options [Hash] :platform_kubernetes_attributes A customizable set of Kubernetes platform attributes
    # @suboption platform_kubernetes_attributes [String] :api_url(required)  The URL to access the Kubernetes API
    # @suboption platform_kubernetes_attributes [String] :token(required)  The token to authenticate against Kubernetes
    # @suboption platform_kubernetes_attributes [String] :ca_cert(optional)   TLS certificate (needed if API is using a self-signed TLS certificate
    # @suboption platform_kubernetes_attributes [String] :namespace(optional)   The unique namespace related to the project
    # @suboption platform_kubernetes_attributes [String] :authorization_type(optional)  The cluster authorization type: rbac, abac or unknown_authorization. Defaults to rbac.
    # @return [Gitlab::ObjectifiedHash] Information about the added project cluster.
    def add_project_cluster(project, name, options = {})
      body = { name: name }.merge(options)
      post("/projects/#{url_encode project}/clusters/user", body: body)
    end

    # Updates an existing project cluster.
    #
    # @example
    #   Gitlab.edit_project_cluster(5, 1, { name: 'cluster-6', platform_kubernetes_attributes: { api_url: 'https://35.111.51.20', token: '12345', ca_cert: "-----BEGIN CERTIFICATE-----\r\nhFiK1L61owwDQYJKoZIhvcNAQELBQAw\r\nLzEtMCsGA1UEAxMkZDA1YzQ1YjctNzdiMS00NDY0LThjNmEtMTQ0ZDJkZjM4ZDBj\r\nMB4XDTE4MTIyNzIwMDM1MVoXDTIzMTIyNjIxMDM1MVowLzEtMCsGA1UEAxMkZDA1\r\nYzQ1YjctNzdiMS00NDY0LThjNmEtMTQ0ZDJkZjM.......-----END CERTIFICATE-----", namespace: 'cluster-6-namespace' } })
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [Integer] cluster_id  The ID of the cluster.
    # @param [Hash] options A customizable set of options.
    # @option options [String] :name(optional) The name of the cluster
    # @option options [Hash] :platform_kubernetes_attributes A customizable set of Kubernetes platform attributes
    # @suboption platform_kubernetes_attributes [String] :api_url(required)  The URL to access the Kubernetes API
    # @suboption platform_kubernetes_attributes [String] :token(required)  The token to authenticate against Kubernetes
    # @suboption platform_kubernetes_attributes [String] :ca_cert(optional)   TLS certificate (needed if API is using a self-signed TLS certificate
    # @suboption platform_kubernetes_attributes [String] :namespace(optional)   The unique namespace related to the project
    # @return [Gitlab::ObjectifiedHash] Information about the updated project cluster.
    def edit_project_cluster(project, cluster_id, options = {})
      put("/projects/#{url_encode project}/clusters/#{cluster_id}", body: options)
    end

    # Deletes an existing project cluster.
    #
    # @example
    #   Gitlab.delete_project_cluster(5, 42)
    #
    # @param [Integer, String] project The ID or name of a project.
    # @param [Integer] cluster_id The ID of the cluster.
    # @return [nil] This API call returns an empty response body.
    def delete_project_cluster(project, cluster_id)
      delete("/projects/#{url_encode project}/clusters/#{cluster_id}")
    end
  end
end
