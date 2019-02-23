# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to markdown.
  # @see https://docs.gitlab.com/ce/api/avatar.html
  module Markdown
    # Render an arbitrary Markdown document
    #
    # @example
    #   Gitlab.markdown(text: 'Hello world! :tada:')
    #   Gitlab.markdown(text: 'Hello world! :tada:', gfm: true, project: 'group_example/project_example')
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :text(required) The markdown text to render.
    # @option options [Boolean] :gfm(optional) Render text using GitLab Flavored Markdown. Default is false.
    # @option options [String] :project(required) Use project as a context when creating references using GitLab Flavored Markdown. Authentication is required if a project is not public.
    # @return <Gitlab::ObjectifiedHash> Returns the rendered markdown as response
    def markdown(options = {})
      post('/markdown', body: options)
    end
  end
end
