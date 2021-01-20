# frozen_string_literal: true

class Gitlab::Client
  # implements methods for group import/export
  # @see https://docs.gitlab.com/ee/api/group_import_export.html
  module GroupImportExport
    # Schedules an export job for a group
    #
    #  @example
    #     Gitlab.group_export(1)
    #     Gitlab.group_export(1, description: "Tribute")
    #
    # @param [Integer] :id(required) Project id to be exported.
    # @return [Gitlab::ObjectifiedHash] Status message for the export request.
    def group_export(id)
      post("/groups/#{id}/export")
    end

    # Download exported group
    #
    # @example
    #    Gitlab.group_export_download(1)
    #
    # @param [Integer/String] :id Group id or path
    # @return [Gitlab::FileResponse]
    def group_export_download(id)
      get("/groups/#{id}/export/download",
          headers: { Accept: 'application/octet-stream' },
          parser: proc { |body, _|
                    if body.encoding == Encoding::ASCII_8BIT # binary response
                      ::Gitlab::FileResponse.new StringIO.new(body, 'rb+')
                    else # error with json response
                      ::Gitlab::Request.parse(body)
                    end
                  })
    end

    # Import a group
    #
    # @example
    #    Gitlab.group_import("""/path/to/archive")
    #
    # @param [String} :name The name of the group to be created.
    # @param [String] :path Name and path for uploaded group
    # @param [String} :file Full path to file.
    # @option [Integer] :parent_id ID of the group to be a parent of the imported group.
    # @return [Gitlab::ObjectifiedHash] Status information for the import job.
    def group_import(name, path, file, parent_id: nil)
      opts = {}
      opts[:name] = name
      opts[:path] = path
      opts[:file] = File.open(file, 'rb')
      opts[:parent_id] = parent_id if parent_id
      post('/groups/import', body: opts)
    end
  end
end
