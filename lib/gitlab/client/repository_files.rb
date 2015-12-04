require 'base64'

class Gitlab::Client
  # Defines methods related to repository files.
  # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/repository_files.md
  module RepositoryFiles
    # Gets a repository file.
    #
    # @example
    #   Gitlab.get_file(42, "README.md", "master")
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] file_path The full path of the file.
    # @param  [String] ref The name of branch, tag or commit.
    # @return [Gitlab::ObjectifiedHash]
    def get_file(project, file_path, ref)
      get("/projects/#{project}/repository/files", query: {
            file_path: file_path,
            ref: ref
          })
    end

    # Creates a new repository file.
    #
    # @example
    #   Gitlab.create_file(42, "path", "branch", "content", "commit message")
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] full path to new file.
    # @param  [String] the name of the branch.
    # @param  [String] file content.
    # @param  [String] commit message.
    # @return [Gitlab::ObjectifiedHash]
    def create_file(project, path, branch, content, commit_message)
      post("/projects/#{project}/repository/files", body: {
        file_path: path,
        branch_name: branch,
        commit_message: commit_message
      }.merge(encoded_content_attributes(content)))
    end

    # Edits an existing repository file.
    #
    # @example
    #   Gitlab.edit_file(42, "path", "branch", "content", "commit message")
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] full path to new file.
    # @param  [String] the name of the branch.
    # @param  [String] file content.
    # @param  [String] commit message.
    # @return [Gitlab::ObjectifiedHash]
    def edit_file(project, path, branch, content, commit_message)
      put("/projects/#{project}/repository/files", body: {
        file_path: path,
        branch_name: branch,
        commit_message: commit_message
      }.merge(encoded_content_attributes(content)))
    end

    # Removes an existing repository file.
    #
    # @example
    #   Gitlab.remove_file(42, "path", "branch", "commit message")
    #
    # @param  [Integer] project The ID of a project.
    # @param  [String] full path to new file.
    # @param  [String] the name of the branch.
    # @param  [String] commit message.
    # @return [Gitlab::ObjectifiedHash]
    def remove_file(project, path, branch, commit_message)
      delete("/projects/#{project}/repository/files", body: {
               file_path: path,
               branch_name: branch,
               commit_message: commit_message
             })
    end

    private

    def encoded_content_attributes(content)
      {
        encoding: 'base64',
        content: Base64.encode64(content)
      }
    end
  end
end
