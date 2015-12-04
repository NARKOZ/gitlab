class Gitlab::Client
  # Defines methods related to users.
  # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/users.md
  # @see https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/session.md
  module Users
    # Gets a list of users.
    #
    # @example
    #   Gitlab.users
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def users(options={})
      get("/users", query: options)
    end

    # Gets information about a user.
    # Will return information about an authorized user if no ID passed.
    #
    # @example
    #   Gitlab.user
    #   Gitlab.user(2)
    #
    # @param  [Integer] id The ID of a user.
    # @return [Gitlab::ObjectifiedHash]
    def user(id=nil)
      id.to_i.zero? ? get("/user") : get("/users/#{id}")
    end

    # Creates a new user.
    # Requires authentication from an admin account.
    #
    # @example
    #   Gitlab.create_user('joe@foo.org', 'secret', 'joe', :name => 'Joe Smith')
    #   or
    #   Gitlab.create_user('joe@foo.org', 'secret')
    #
    # @param  [String] email The email of a user.
    # @param  [String] password The password of a user.
    # @param  [String] username The username of a user.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :name The name of a user. Defaults to email.
    # @option options [String] :skype The skype of a user.
    # @option options [String] :linkedin The linkedin of a user.
    # @option options [String] :twitter The twitter of a user.
    # @option options [Integer] :projects_limit The limit of projects for a user.
    # @return [Gitlab::ObjectifiedHash] Information about created user.
    def create_user(*args)
      options = Hash === args.last ? args.pop : {}
      if args[2]
        body = { email: args[0], password: args[1], username: args[2] }
      else
        body = { email: args[0], password: args[1], name: args[0] }
      end
      body.merge!(options)
      post('/users', body: body)
    end

    # Updates a user.
    #
    # @example
    #   Gitlab.edit_user(15, :email => 'joe.smith@foo.org', :projects_limit => 20)
    #
    # @param  [Integer] id The ID of a user.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :email The email of a user.
    # @option options [String] :password The password of a user.
    # @option options [String] :name The name of a user. Defaults to email.
    # @option options [String] :skype The skype of a user.
    # @option options [String] :linkedin The linkedin of a user.
    # @option options [String] :twitter The twitter of a user.
    # @option options [Integer] :projects_limit The limit of projects for a user.
    # @return [Gitlab::ObjectifiedHash] Information about created user.
    def edit_user(user_id, options={})
      put("/users/#{user_id}", body: options)
    end

    # Deletes a user.
    #
    # @example
    #   Gitlab.delete_user(1)
    #
    # @param [Integer] id The ID of a user.
    # @return [Gitlab::ObjectifiedHash] Information about deleted user.
    def delete_user(user_id)
      delete("/users/#{user_id}")
    end

    # Blocks the specified user. Available only for admin.
    #
    # @example
    #   Gitlab.block_user(15)
    #
    # @param [Integer] user_id The Id of user
    # @return [Boolean] success or not
    def block_user(user_id)
      put("/users/#{user_id}/block")
    end

    # Unblocks the specified user. Available only for admin.
    #
    # @example
    #   Gitlab.unblock_user(15)
    #
    # @param [Integer] user_id The Id of user
    # @return [Boolean] success or not
    def unblock_user(user_id)
      put("/users/#{user_id}/unblock")
    end

    # Creates a new user session.
    #
    # @example
    #   Gitlab.session('jack@example.com', 'secret12345')
    #
    # @param  [String] email The email of a user.
    # @param  [String] password The password of a user.
    # @return [Gitlab::ObjectifiedHash]
    # @note This method doesn't require private_token to be set.
    def session(email, password)
      post("/session", body: { email: email, password: password })
    end

    # Gets a list of user's SSH keys.
    #
    # @example
    #   Gitlab.ssh_keys
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def ssh_keys(options={})
      get("/user/keys", query: options)
    end

    # Gets information about SSH key.
    #
    # @example
    #   Gitlab.ssh_key(1)
    #
    # @param  [Integer] id The ID of a user's SSH key.
    # @return [Gitlab::ObjectifiedHash]
    def ssh_key(id)
      get("/user/keys/#{id}")
    end

    # Creates a new SSH key.
    #
    # @example
    #   Gitlab.create_ssh_key('key title', 'key body')
    #
    # @param  [String] title The title of an SSH key.
    # @param  [String] key The SSH key body.
    # @return [Gitlab::ObjectifiedHash] Information about created SSH key.
    def create_ssh_key(title, key)
      post("/user/keys", body: { title: title, key: key })
    end

    # Deletes an SSH key.
    #
    # @example
    #   Gitlab.delete_ssh_key(1)
    #
    # @param  [Integer] id The ID of a user's SSH key.
    # @return [Gitlab::ObjectifiedHash] Information about deleted SSH key.
    def delete_ssh_key(id)
      delete("/user/keys/#{id}")
    end
  end
end
