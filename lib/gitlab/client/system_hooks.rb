class Gitlab::Client
  # Defines methods related to system hooks.
  # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/system_hooks.md
  module SystemHooks
    # Gets a list of system hooks.
    #
    # @example
    #   Gitlab.hooks
    #   Gitlab.system_hooks
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def hooks(options={})
      get("/hooks", query: options)
    end
    alias_method :system_hooks, :hooks

    # Adds a new system hook.
    #
    # @example
    #   Gitlab.add_hook('http://example.com/hook')
    #   Gitlab.add_system_hook('https://api.example.net/v1/hook')
    #
    # @param  [String] url The hook URL.
    # @return [Gitlab::ObjectifiedHash]
    def add_hook(url)
      post("/hooks", body: { url: url })
    end
    alias_method :add_system_hook, :add_hook

    # Tests a system hook.
    #
    # @example
    #   Gitlab.hook(3)
    #   Gitlab.system_hook(12)
    #
    # @param  [Integer] id The ID of a system hook.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def hook(id)
      get("/hooks/#{id}")
    end
    alias_method :system_hook, :hook

    # Deletes a new system hook.
    #
    # @example
    #   Gitlab.delete_hook(3)
    #   Gitlab.delete_system_hook(12)
    #
    # @param  [Integer] id The ID of a system hook.
    # @return [Gitlab::ObjectifiedHash]
    def delete_hook(id)
      delete("/hooks/#{id}")
    end
    alias_method :delete_system_hook, :delete_hook
  end
end
