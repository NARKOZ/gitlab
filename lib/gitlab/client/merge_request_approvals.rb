# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to MR Approvals.
  # @see https://docs.gitlab.com/ee/api/merge_request_approvals.html
  module MergeRequestApprovals
    # Gets MR Approval Configuration for a project
    #
    # @example
    #   Gitlab.project_merge_request_approvals(1)
    #
    # @param [Integer] project The ID of a project.
    # @return [Gitlab::ObjectifiedHash] MR approval configuration information about the project
    def project_merge_request_approvals(project)
      get("/projects/#{url_encode project}/approvals")
    end

    # Change MR Approval Configuration for a project
    #
    # @example
    #    Gitlab.edit_project_merge_request_approvals(1, {approvals_before_merge: 3})
    #    Gitlab.edit_project_merge_request_approvals(1, {approvals_before_merge: 3, reset_approvals_on_push: true})
    #    Gitlab.edit_project_merge_request_approvals(1, {approvals_before_merge: 3, disable_overriding_approvers_per_merge_request: false})
    #
    # @param [Integer] project(required) The ID of a project.
    # @option options [Integer] :approvals_before_merge(optional) How many approvals are required before an MR can be merged
    # @option options [Boolean] :reset_approvals_on_push(optional) Reset approvals on a new push
    # @option options [Boolean] :disable_overriding_approvers_per_merge_request(optional) Allow/Disallow overriding approvers per MR
    # @return [Gitlab::ObjectifiedHash] MR approval configuration information about the project
    def edit_project_merge_request_approvals(project, options = {})
      post("/projects/#{url_encode project}/approvals", body: options)
    end

    # Gets MR Approval Rules for a project
    #
    # @example
    #   Gitlab.project_merge_request_approval_rules(1)
    #
    # @param [Integer] project The ID of a project.
    # @return [Gitlab::ObjectifiedHash] MR approval rules for the project
    def project_merge_request_approval_rules(project)
      get("/projects/#{url_encode project}/approval_rules")
    end

    # Create MR Approval Rule for a project
    #
    # @example
    #   Gitlab.create_project_merge_request_approval_rule(1, {name: "security", approvals_required: 1})
    #
    # @param [Integer] project(required) The ID of a project.
    # @option options [String] :name(required) The name of the approval rule
    # @option options [Integer] :approvals_required(required) The number of required approvals for this rule
    # @option options [Array] :user_ids(optional) The ids of users as approvers
    # @option options [Array] :group_ids(optional) The ids of groups as approvers
    # @option options [Array] :protected_branch_ids(optional) The ids of protected branches to scope the rule by
    # @return [Gitlab::ObjectifiedHash] New MR approval rule
    def create_project_merge_request_approval_rule(project, options = {})
      post("/projects/#{url_encode project}/approval_rules", body: options)
    end

    # Update MR Approval Rule for a project
    #
    # @example
    #   Gitlab.update_project_merge_request_approval_rule(1, {name: "security", approvals_required: 2})
    #
    # @param [Integer] project(required) The ID of a project.
    # @param [Integer] approval_rule_id(required) The ID of a project Approval Rule
    # @option options [String] :name(required) The name of the approval rule
    # @option options [Integer] :approvals_required(required) The number of required approvals for this rule
    # @option options [Array] :user_ids(optional) The ids of users as approvers
    # @option options [Array] :group_ids(optional) The ids of groups as approvers
    # @option options [Array] :protected_branch_ids(optional) The ids of protected branches to scope the rule by
    # @return [Gitlab::ObjectifiedHash] Updated MR approval rule
    def update_project_merge_request_approval_rule(project, approval_rule_id, options = {})
      put("/projects/#{url_encode project}/approval_rules/#{approval_rule_id}", body: options)
    end

    # Delete MR Approval Rule for a project
    #
    # @example
    #   Gitlab.delete_project_merge_request_approval_rule(1, 1)
    #
    # @param [Integer] project(required) The ID of a project.
    # @param [Integer] approval_rule_id(required) The ID of a approval rule
    # @return [void] This API call returns an empty response body
    def delete_project_merge_request_approval_rule(project, approval_rule_id)
      delete("/projects/#{url_encode project}/approval_rules/#{approval_rule_id}")
    end

    # Change allowed approvers and approver groups for a project
    # @deprecated Since Gitlab 13.12 /approvers endpoints are removed!!!
    # See Gitlab.create_project_merge_request_approval_rule
    #
    # @example
    #    Gitlab.edit_project_approvers(1, {approver_ids: [5], approver_groups: [1]})
    #
    # @param [Integer] project(required) The ID of a project.
    # @option options [Array] :approver_ids(required, nil if none) An array of User IDs that can approve MRs
    # @option options [Array] :approver_group_ids(required, nil if none) An array of Group IDs whose members can approve MRs
    # @return [Gitlab::ObjectifiedHash] MR approval configuration information about the project
    def edit_project_approvers(project, options = {})
      put("/projects/#{url_encode project}/approvers", body: options)
    end

    # Get Configuration for approvals on a specific Merge Request.
    #
    # @example
    #    Gitlab.merge_request_approvals(1, 5)
    #
    # @param [Integer] project(required) The ID of a project.
    # @param [Integer] merge_request(required) The IID of a merge_request.
    # @return [Gitlab::ObjectifiedHash] MR approval configuration information about the merge request
    def merge_request_approvals(project, merge_request)
      get("/projects/#{url_encode project}/merge_requests/#{merge_request}/approvals")
    end

    # Change configuration for approvals on a specific merge request.
    #
    # @example
    #    Gitlab.edit_merge_request_approvals(1, 5, approvals_required: 2)
    #
    # @param [Integer] project(required) The ID of a project.
    # @param [Integer] merge_request(required) The IID of a merge_request.
    # @option options [Integer] :approvals_required(required) Approvals required before MR can be merged
    # @return [Gitlab::ObjectifiedHash] Updated MR approval configuration information about the merge request
    def edit_merge_request_approvals(project, merge_request, options = {})
      post("/projects/#{url_encode project}/merge_requests/#{merge_request}/approvals", body: options)
    end

    # Change allowed approvers and approver groups for a merge request
    # @deprecated Since Gitlab 13.12 /approvers endpoints are removed!!!
    # See Gitlab.create_merge_request_level_rule
    #
    # @example
    #    Gitlab.edit_merge_request_approvers(1, 5, {approver_ids: [5], approver_groups: [1]})
    #
    # @param [Integer] project(required) The ID of a project.
    # @param [Integer] merge_request(required) The IID of a merge_request.
    # @option options [Array] :approver_ids(required, nil if none) An array of User IDs that can approve MRs
    # @option options [Array] :approver_group_ids(required, nil if none) An array of Group IDs whose members can approve MRs
    # @return [Gitlab::ObjectifiedHash] MR approval configuration information about the project
    def edit_merge_request_approvers(project, merge_request, options = {})
      put("/projects/#{url_encode project}/merge_requests/#{merge_request}/approvers", body: options)
    end

    # Create merge request level rule
    #
    # @example
    #   Gitlab.create_merge_request_level_rule(1, 2, {
    #     name: "devs",
    #     approvals_required: 2,
    #     approval_project_rule_id: 99,
    #     user_ids: [3, 4],
    #     group_ids: [5, 6],
    #   })
    #
    # Important: When approval_project_rule_id is set, the name, users and groups of project-level rule are copied.
    # The approvals_required specified is used.
    #
    # @param [Integer] project(required) The ID of a project.
    # @param [Integer] merge_request(required) The IID of a merge request.
    # @option options [String] :name(required) The name of the approval rule
    # @option options [Integer] :approvals_required(required) The number of required approvals for this rule
    # @option options [Integer] :approval_project_rule_id(optional) The ID of a project-level approval rule
    # @option options [Array] :user_ids(optional) The ids of users as approvers
    # @option options [Array] :group_ids(optional) The ids of groups as approvers
    # @return [Gitlab::ObjectifiedHash] New MR level approval rule
    def create_merge_request_level_rule(project, merge_request, options = {})
      post("/projects/#{url_encode project}/merge_requests/#{merge_request}/approval_rules", body: options)
    end

    # Get merge request level rule
    #
    # @example
    #   Gitlab.merge_request_level_rule(1, 2)
    #
    # @param [Integer] project(required) The ID of a project.
    # @param [Integer] merge_request(required) The IID of a merge request.
    # @return [Gitlab::ObjectifiedHash] New MR level approval rule
    def merge_request_level_rule(project, merge_request)
      get("/projects/#{url_encode project}/merge_requests/#{merge_request}/approval_rules")
    end

    # Update merge request level rule
    #
    # @example
    #   Gitlab.update_merge_request_level_rule(1, 2, 69, {
    #     name: "devs",
    #     approvals_required: 2,
    #     user_ids: [3, 4],
    #     group_ids: [5, 6],
    #   })
    #
    # Important: Approvers and groups not in the users/groups parameters are removed
    # Important: Updating a report_approver or code_owner rule is not allowed.
    # These are system generated rules.
    #
    # @param [Integer] project(required) The ID of a project.
    # @param [Integer] merge_request(required) The IID of a merge request.
    # @param [Integer] appr_rule_id(required) The ID of a approval rule
    # @option options [String] :name(required) The name of the approval rule
    # @option options [Integer] :approvals_required(required) The number of required approvals for this rule
    # @option options [Array] :user_ids(optional) The ids of users as approvers
    # @option options [Array] :group_ids(optional) The ids of groups as approvers
    # @return [Gitlab::ObjectifiedHash] Updated MR level approval rule
    def update_merge_request_level_rule(project, merge_request, appr_rule_id, options = {})
      put("/projects/#{url_encode project}/merge_requests/#{merge_request}/approval_rules/#{appr_rule_id}", body: options)
    end

    # Delete merge request level rule
    #
    # @example
    #   Gitlab.delete_merge_request_level_rule(1, 2, 69)
    #
    # Important: Deleting a report_approver or code_owner rule is not allowed.
    # These are system generated rules.
    #
    # @param [Integer] project(required) The ID of a project.
    # @param [Integer] merge_request(required) The IID of a merge request.
    # @param [Integer] appr_rule_id(required) The ID of a approval rule
    # @return [void] This API call returns an empty response body
    def delete_merge_request_level_rule(project, merge_request, appr_rule_id)
      delete("/projects/#{url_encode project}/merge_requests/#{merge_request}/approval_rules/#{appr_rule_id}")
    end

    # Approve a merge request
    #
    # @example
    #    Gitlab.approve_merge_request(1, 5)
    #    Gitlab.approve_merge_request(1, 5, sha: 'fe678da')
    #
    # @param [Integer] project(required) The ID of a project.
    # @param [Integer] merge_request(required) The IID of a merge request.
    # @option options [String] :sha(optional) The HEAD of the MR
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
    # @option options [String] :sudo(optional) The username of the user you want to remove the approval for
    # @return [void] This API call returns an empty response body.
    def unapprove_merge_request(project, merge_request, options = {})
      post("/projects/#{url_encode project}/merge_requests/#{merge_request}/unapprove", body: options)
    end

    # Get the approval state of merge requests
    #
    # @example
    #   Gitlab.merge_request_approval_state(5, 36)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of a merge request.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def merge_request_approval_state(project, id)
      get("/projects/#{url_encode project}/merge_requests/#{id}/approval_state")
    end
  end
end
