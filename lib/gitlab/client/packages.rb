# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to GitLab Packages.
  # @see https://docs.gitlab.com/ee/api/packages.html
  module Packages
    # Gets a list of project packages.
    #
    # @example
    #   Gitlab.project_packages(5)
    #   Gitlab.project_packages(5, { package_type: 'npm', sort: 'desc' })
    #
    # @param   [Integer, String] :project the ID or name of a project.
    # @param   [Hash] options A customizable set of options.
    # @options options [String] :order_by The field to use as order. One of created_at (default), name, version, or type.
    # @options options [String] :sort The direction of the order, either asc (default) for ascending order or desc for descending order.
    # @options options [String] :package_type Filter the returned packages by type. One of conan, maven, npm, pypi, composer, nuget, helm, terraform_module, or golang.
    # @options options [String] :package_name Filter the project packages with a fuzzy search by name.
    # @options options [String] :include_versionless When set to true, versionless packages are included in the response.
    # @options options [String] :status Filter the returned packages by status. One of default (default), hidden, processing, error, or pending_destruction.
    # @return  [Array<Gitlab::ObjectifiedHash>]
    def project_packages(project, options = {})
      get("/projects/#{url_encode project}/packages", query: options)
    end

    # Gets a list of project packages.
    #
    # @example
    #   Gitlab.group_packages(5)
    #   Gitlab.group_packages(5, { package_type: 'npm', sort: 'desc' })
    #
    # @param   [Integer, String] project the ID or name of a project.
    # @param   [Hash] options A customizable set of options.
    # @options options [String] :exclude_subgroups If the parameter is included as true, packages from projects from subgroups are not listed. Default is false.
    # @options options [String] :order_by The field to use as order. One of created_at (default), name, version, or type.
    # @options options [String] :sort The direction of the order, either asc (default) for ascending order or desc for descending order.
    # @options options [String] :package_type Filter the returned packages by type. One of conan, maven, npm, pypi, composer, nuget, helm, terraform_module, or golang.
    # @options options [String] :package_name Filter the project packages with a fuzzy search by name.
    # @options options [String] :include_versionless When set to true, versionless packages are included in the response.
    # @options options [String] :status Filter the returned packages by status. One of default (default), hidden, processing, error, or pending_destruction.
    # @return  [Array<Gitlab::ObjectifiedHash>]
    def group_packages(group, options = {})
      get("/groups/#{url_encode group}/packages", query: options)
    end

    # Get a single project package.
    #
    # @example
    #   Gitlab.project_package(5, 3)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id ID of a package.
    # @return [Gitlab::ObjectifiedHash]
    def project_package(project, id)
      get("/projects/#{url_encode project}/packages/#{id}")
    end

    # Get a list of package files of a single package.
    #
    # @example
    #   Gitlab.project_package_files(5, 3)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id ID of a package.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def project_package_files(project, id)
      get("/projects/#{url_encode project}/packages/#{id}/package_files")
    end

    # Deletes a project package.
    #
    # @example
    #   Gitlab.delete_project_package(5, 3)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id ID of a package.
    # @return [void] This API call returns an empty response body.
    def delete_project_package(project, id)
      delete("/projects/#{url_encode project}/packages/#{id}")
    end

    # Delete a package file.
    #
    # @example
    #   Gitlab.delete_project_file(5, 3, 1)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] package_id ID of a package.
    # @param  [Integer] file_id ID of a package file.
    # @return [void] This API call returns an empty response body.
    def delete_project_package_file(project, package_id, file_id)
      delete("/projects/#{url_encode project}/packages/#{package_id}/package_files/#{file_id}")
    end
  end
end
