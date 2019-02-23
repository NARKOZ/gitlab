# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to markdown.
  # @see https://docs.gitlab.com/ce/api/markdown.html
  module Markdown
    # Render an arbitrary Markdown document
    #
    # @example
    #   Gitlab.markdown('Hello world! :tada:')
    #   Gitlab.markdown('Hello world! :tada:', gfm: true, project: 'group_example/project_example')
    #
    # @param  [String] text The markdown text to render.
    # @param  [Hash] options A customizable set of options.
    # @option options [Boolean] :gfm(optional) Render text using GitLab Flavored Markdown. Default is false.
    # @option options [String] :project(optional) Use project as a context when creating references using GitLab Flavored Markdown. Authentication is required if a project is not public.
    # @return <Gitlab::ObjectifiedHash> Returns the rendered markdown as response
    def markdown(text, options = {})
      body = { text: text }.merge(options)
      post('/markdown', body: body)
    end
  end
end
