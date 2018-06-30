class Gitlab::Client
  # Defines methods related to MR Approvals.
  # @see https://docs.gitlab.com/ee/api/merge_request_approvals.html
  module MergeRequestApprovals
    # Gets MR Approval Configuration for a project
    #
    # @example
    #   Gitlab.project_mr_approvals_configuration(1)
    #
    # @param [Integer] project The ID of a project.
    # @return [Gitlab::ObjectifiedHash] MR approval configuration information about the project
    def project_mr_approvals_configuration(project)
      get("/projects/#{url_encode project}/approvals")
    end

    # Change MR Approval Configuration for a project
    #
    # @example
    #    Gitlab.change_project_mr_approvals_configuration(1, {approvals_before_merge: 3})
    #    Gitlab.change_project_mr_approvals_configuration(1, {approvals_before_merge: 3, reset_approvals_on_push: true})
    #    Gitlab.change_project_mr_approvals_configuration(1, {approvals_before_merge: 3, disable_overriding_approvers_per_merge_request: false})
    #
    # @param [Integer] project(required) The ID of a project.
    # @option options [Integer] :approvals_before_merge(optional) How many approvals are required before an MR can be merged
    # @option options [Boolean] :reset_approvals_on_push(optional) Reset approvals on a new push
    # @option options [Boolean] :disable_overriding_approvers_per_merge_request(optional) Allow/Disallow overriding approvers per MR
    # @return [Gitlab::ObjectifiedHash] MR approval configuration information about the project
    def change_project_mr_approvals_configuration(project, options = {})
      post("/projects/#{url_encode project}/approvals", body: options)
    end

    # Change allowed approvers and approver groups for a project
    #
    # @example
    #    Gitlab.change_project_approvers(1, {approver_ids: [5], approver_groups: [1]})
    #
    # @param [Integer] project(required) The ID of a project.
    # @option options [Array] :approver_ids(optional) An array of User IDs that can approve MRs
    # @option options [Array] :approver_group_ids(optional) An array of Group IDs whose members can approve MRs
    # @return [Gitlab::ObjectifiedHash] MR approval configuration information about the project
    def change_project_approvers(project, options = {})
      put("/projects/#{url_encode project}/approvals", body: options)
    end

    # Get Configuration for approvals on a specific Merge Request.
    #
    # @example
    #    Gitlab.merge_request_mr_approvals_configuration(1, 5)
    #
    # @param [Integer] project(required) The ID of a project.
    # @param [Integer] merge_request(required) The IID of a merge_request.
    # @return [Gitlab::ObjectifiedHash] MR approval configuration information about the merge request
    def merge_request_mr_approvals_configuration(project, merge_request)
      get("/projects/#{url_encode project}/merge_requests/#{merge_request}/approvals")
    end

    # Change configuration for approvals on a specific merge request.
    #
    # @example
    #    Gitlab.change_merge_request_mr_approvals_configuration(1, 5, approvals_required: 2)
    #
    # @param [Integer] project(required) The ID of a project.
    # @param [Integer] merge_request(required) The IID of a merge_request.
    # @option options [Integer] :approvals_required(required) Approvals required before MR can be merged
    # @return [Gitlab::ObjectifiedHash] Updated MR approval configuration information about the merge request
    def change_merge_request_mr_approvals_configuration(project, merge_request, options = {})
      post("/projects/#{url_encode project}/merge_requests/#{merge_request}/approvals", body: options)
    end

    # Change allowed approvers and approver groups for a merge request
    #
    # @example
    #    Gitlab.change_merge_request_approvers(1, 5, {approver_ids: [5], approver_groups: [1]})
    #
    # @param [Integer] project(required) The ID of a project.
    # @param [Integer] merge_request(required) The IID of a merge_request.
    # @option options [Array] :approver_ids(optional) An array of User IDs that can approve MRs
    # @option options [Array] :approver_group_ids(optional) An array of Group IDs whose members can approve MRs
    # @return [Gitlab::ObjectifiedHash] MR approval configuration information about the project
    def change_merge_request_approvers(project, merge_request, options = {})
      put("/projects/#{url_encode project}/merge_requests/#{merge_request}/approvals", body: options)
    end

    # Approve a merge request
    #
    # @example
    #    Gitlab.approve_merge_request(1, 5)
    #    Gitlab.approve_merge_request(1, 5, sha: 'fe678da')
    #
    # @param [Integer] project(required) The ID of a project.
    # @param [Integer] merge_request(required) The IID of a merge request.
    # @option options [String] :sha(required) The HEAD of the MR
    # @return [Gitlab::ObjectifiedHash] MR approval configuration information about the project
    def approve_merge_request(project, merge_request, options = {})
      post("/projects/#{url_encode project}/merge_requests/#{merge_request}/approve", body: options)
    end

    # Unapprove a merge request
    #
    # @example
    #    Gitlab.unapprove_merge_request(1, 5)
    #
    # @param [Integer] project(required) The ID of a project.
    # @param [Integer] merge_request(required) The IID of a merge request.
    # @return [void] This API call returns an empty response body.
    def unapprove_merge_request(project, merge_request)
      post("/projects/#{url_encode project}/merge_requests/#{merge_request}/unapprove")
    end
  end
end