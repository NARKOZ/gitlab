# frozen_string_literal: true
require 'json'

class Gitlab::Client
  # Defines methods related to project approval rules.
  # Does not exist in API documentation
  module ApprovalRules
    # Deletes the approval role from the project approval settings. Approval rules come within the approval settings.
    #
    # @example
    #   Gitlab.delete_approval_rule(1, 133)
    #   Gitlab.delete_approval_rule("project", 133)
    #
    # @param  [Integer, String] id The ID or name of a project.
    # @param  [Integer, String] id The ID of the rule to be deleted.
    # @return [void] This API call returns an empty response body.
    def delete_approval_rule(project, approval_rule_id)
      delete("/projects/#{url_encode project}/approval_settings/rules/#{url_encode approval_rule_id}")
    end

    # Crates an approval rule with the name and settings provided
    #
    # @example
    #   Gitlab.create_approval_rule(1, "Default",  { :approvals_required => 2, :users =>[], :groups => [1, 2], :remove_hidden_groups => false })
    #   Gitlab.delete_approval_rule("project", "Default", { :approvals_required => 2, :users =>[], :groups => [1, 2], :remove_hidden_groups => false })
    #
    # @param  [Integer, String] id The ID or name of a project.
    # @param  [Integer, String] id The ID of the rule to be deleted.
    # @option options [Integer] :approvals_required(optional) #Number of approvals required
    # @option options [Array] :users(optional) #Number of approvals required
    # @option options [Array] :groups(optional) #Number of approvals required
    # @option options [Array] :remove_hidden_groups(optional) #Number of approvals required
    # @return [Array<Gitlab::ObjectifiedHash>]
    def create_approval_rule(project, rule_name, options = {})
      body = { name: rule_name }.merge(options)
      settings = post("/projects/#{url_encode project}/approval_settings/rules", body: body)
    end

  end
end
