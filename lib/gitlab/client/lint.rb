# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to lint/validations.
  # @see https://docs.gitlab.com/ce/api/lint.html
  module Lint
    # Checks if your .gitlab-ci.yml file is valid.
    #
    # @example
    #   Gitlab.validate_gitlab_ci_yml("{ \"image\": \"ruby:2.6\", \"services\": [\"postgres\"], \"before_script\": [\"bundle install\", \"bundle exec rake db:create\"], \"variables\": {\"DB_NAME\": \"postgres\"}, \"types\": [\"test\", \"deploy\", \"notify\"], \"rspec\": { \"script\": \"rake spec\", \"tags\": [\"ruby\", \"postgres\"], \"only\": [\"branches\"]}}")
    #
    # @param  [String] content the .gitlab-ci.yaml content.
    # @return <Gitlab::ObjectifiedHash> Returns information about validity of the yml.
    def validate_gitlab_ci_yml(content)
      body = { content: content }
      post('/lint', body: body)
    end
  end
end
