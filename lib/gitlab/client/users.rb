# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to users.
  # @see https://docs.gitlab.com/ce/api/users.html
  # @see https://docs.gitlab.com/ce/api/session.html
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
    def users(options = {})
      get('/users', query: options)
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
    def user(id = nil)
      id.to_i.zero? ? get('/user') : get("/users/#{id}")
    end

    # Creates a new user.
    # Requires authentication from an admin account.
    #
    # @example
    #   Gitlab.create_user('joe@foo.org', 'secret', 'joe', { name: 'Joe Smith' })
    #   or
    #   Gitlab.create_user('joe@foo.org', 'secret', 'joe')
    #
    # @param  [String] email(required) The email of a user.
    # @param  [String] password(required) The password of a user.
    # @param  [String] username(required) The username of a user.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :name The name of a user. Defaults to email.
    # @option options [String] :skype The skype of a user.
    # @option options [String] :linkedin The linkedin of a user.
    # @option options [String] :twitter The twitter of a user.
    # @option options [Integer] :projects_limit The limit of projects for a user.
    # @return [Gitlab::ObjectifiedHash] Information about created user.
    def create_user(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      raise ArgumentError, 'Missing required parameters' unless args[2]

      body = { email: args[0], password: args[1], username: args[2], name: args[0] }
      body.merge!(options)
      post('/users', body: body)
    end

    # Updates a user.
    #
    # @example
    #   Gitlab.edit_user(15, { email: 'joe.smith@foo.org', projects_limit: 20 })
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
    def edit_user(user_id, options = {})
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
      post("/users/#{user_id}/block")
    end

    # Unblocks the specified user. Available only for admin.
    #
    # @example
    #   Gitlab.unblock_user(15)
    #
    # @param [Integer] user_id The Id of user
    # @return [Boolean] success or not
    def unblock_user(user_id)
      post("/users/#{user_id}/unblock")
    end

    # Approves the specified user. Available only for admin.
    #
    # @example
    #   Gitlab.approve_user(15)
    #
    # @param [Integer] user_id The Id of user
    # @return [Boolean] success or not
    def approve_user(user_id)
      post("/users/#{user_id}/approve")
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
      post('/session', body: { email: email, password: password }, unauthenticated: true)
    end

    # Gets a list of user activities (for admin access only).
    #
    # @example
    #   Gitlab.activities
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @option options [String] :from The start date for paginated results.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def activities(options = {})
      get('/user/activities', query: options)
    end

    # Gets a list of user's SSH keys.
    #
    # @example
    #   Gitlab.ssh_keys
    #   Gitlab.ssh_keys({ user_id: 2 })
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @option options [Integer] :user_id The ID of the user to retrieve the keys for.
    # @return [Array<Gitlab::ObjectifiedHash>]
    def ssh_keys(options = {})
      user_id = options.delete :user_id
      if user_id.to_i.zero?
        get('/user/keys', query: options)
      else
        get("/users/#{user_id}/keys", query: options)
      end
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
    # @param  [Hash] options A customizable set of options.
    # @option options  [Integer] :user_id id of the user to associate the key with
    # @return [Gitlab::ObjectifiedHash] Information about created SSH key.
    def create_ssh_key(title, key, options = {})
      user_id = options.delete :user_id
      if user_id.to_i.zero?
        post('/user/keys', body: { title: title, key: key })
      else
        post("/users/#{user_id}/keys", body: { title: title, key: key })
      end
    end

    # Deletes an SSH key.
    #
    # @example
    #   Gitlab.delete_ssh_key(1)
    #
    # @param  [Integer] id The ID of a user's SSH key.
    # @param  [Hash] options A customizable set of options.
    # @option options  [Integer] :user_id id of the user to associate the key with
    # @return [Gitlab::ObjectifiedHash] Information about deleted SSH key.
    def delete_ssh_key(id, options = {})
      user_id = options.delete :user_id
      if user_id.to_i.zero?
        delete("/user/keys/#{id}")
      else
        delete("/users/#{user_id}/keys/#{id}")
      end
    end

    # Gets user emails.
    # Will return emails an authorized user if no user ID passed.
    #
    # @example
    #   Gitlab.emails
    #   Gitlab.emails(2)
    #
    # @param  [Integer] user_id The ID of a user.
    # @return [Gitlab::ObjectifiedHash]
    def emails(user_id = nil)
      url = user_id.to_i.zero? ? '/user/emails' : "/users/#{user_id}/emails"
      get(url)
    end

    # Get a single email.
    #
    # @example
    #   Gitlab.email(3)
    #
    # @param  [Integer] id The ID of a email.
    # @return [Gitlab::ObjectifiedHash]
    def email(id)
      get("/user/emails/#{id}")
    end

    # Creates a new email
    # Will create a new email an authorized user if no user ID passed.
    #
    # @example
    #   Gitlab.add_email('email@example.com')
    #   Gitlab.add_email('email@example.com', 2)
    #
    # @param  [String] email Email address
    # @param  [Integer] user_id The ID of a user.
    # @param  [Boolean] skip_confirmation     Skip confirmation and assume e-mail is verified
    # @return [Gitlab::ObjectifiedHash]
    def add_email(email, user_id = nil, skip_confirmation = nil)
      url = user_id.to_i.zero? ? '/user/emails' : "/users/#{user_id}/emails"
      if skip_confirmation.nil?
        post(url, body: { email: email })
      else
        post(url, body: { email: email, skip_confirmation: skip_confirmation })
      end
    end

    # Delete email
    # Will delete a email an authorized user if no user ID passed.
    #
    # @example
    #   Gitlab.delete_email(2)
    #   Gitlab.delete_email(3, 2)
    #
    # @param  [Integer] id Email address ID
    # @param  [Integer] user_id The ID of a user.
    # @return [Boolean]
    def delete_email(id, user_id = nil)
      url = user_id.to_i.zero? ? "/user/emails/#{id}" : "/users/#{user_id}/emails/#{id}"
      delete(url)
    end

    # Search for groups by name
    #
    # @example
    #   Gitlab.user_search('gitlab')
    #
    # @param  [String] search A string to search for in user names and paths.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :per_page Number of user to return per page
    # @option options [String] :page The page to retrieve
    # @return [Array<Gitlab::ObjectifiedHash>]
    def user_search(search, options = {})
      options[:search] = search
      get('/users', query: options)
    end

    # Gets user custom_attributes.
    #
    # @example
    #   Gitlab.user_custom_attributes(2)
    #
    # @param  [Integer] user_id The ID of a user.
    # @return [Gitlab::ObjectifiedHash]
    def user_custom_attributes(user_id)
      get("/users/#{user_id}/custom_attributes")
    end

    # Gets single user custom_attribute.
    #
    # @example
    #   Gitlab.user_custom_attribute(key, 2)
    #
    # @param  [String] key The custom_attributes key
    # @param  [Integer] user_id The ID of a user.
    # @return [Gitlab::ObjectifiedHash]
    def user_custom_attribute(key, user_id)
      get("/users/#{user_id}/custom_attributes/#{key}")
    end

    # Creates a new custom_attribute
    #
    # @example
    #   Gitlab.add_custom_attribute('some_new_key', 'some_new_value', 2)
    #
    # @param  [String] key The custom_attributes key
    # @param  [String] value The custom_attributes value
    # @param  [Integer] user_id The ID of a user.
    # @return [Gitlab::ObjectifiedHash]
    def add_user_custom_attribute(key, value, user_id)
      url = "/users/#{user_id}/custom_attributes/#{key}"
      put(url, body: { value: value })
    end

    # Delete custom_attribute
    # Will delete a custom_attribute
    #
    # @example
    #   Gitlab.delete_user_custom_attribute('somekey', 2)
    #
    # @param  [String] key The custom_attribute key to delete
    # @param  [Integer] user_id The ID of a user.
    # @return [Boolean]
    def delete_user_custom_attribute(key, user_id)
      delete("/users/#{user_id}/custom_attributes/#{key}")
    end

    # Get all impersonation tokens for a user
    #
    # @example
    #   Gitlab.user_impersonation_tokens(1)
    #
    # @param  [Integer] user_id The ID of the user.
    # @param  [String] state Filter impersonation tokens by state {}
    # @return [Array<Gitlab::ObjectifiedHash>]
    def user_impersonation_tokens(user_id)
      get("/users/#{user_id}/impersonation_tokens")
    end

    # Get impersonation token information
    #
    # @example
    #   Gitlab.user_impersonation_token(1, 1)
    #
    # @param  [Integer] user_id The ID of the user.
    # @param  [Integer] impersonation_token_id ID of the impersonation token.
    # @return [Gitlab::ObjectifiedHash]
    def user_impersonation_token(user_id, impersonation_token_id)
      get("/users/#{user_id}/impersonation_tokens/#{impersonation_token_id}")
    end

    # Create impersonation token
    #
    # @example
    #   Gitlab.create_user_impersonation_token(2, "token", ["api", "read_user"])
    #   Gitlab.create_user_impersonation_token(2, "token", ["api", "read_user"], "1970-01-01")
    #
    # @param  [Integer] user_id The ID of the user.
    # @param  [String] name Name for impersonation token.
    # @param  [Array<String>] scopes Array of scopes for the impersonation token
    # @param  [String] expires_at Date for impersonation token expiration in ISO format.
    # @return [Gitlab::ObjectifiedHash]
    def create_user_impersonation_token(user_id, name, scopes, expires_at = nil)
      body = { name: name, scopes: scopes }
      body[:expires_at] = expires_at if expires_at
      post("/users/#{user_id}/impersonation_tokens", body: body)
    end

    # Revoke an impersonation token
    #
    # @example
    #   Gitlab.revoke_user_impersonation_token(1, 1)
    #
    # @param  [Integer] user_id The ID of the user.
    # @param  [Integer] impersonation_token_id ID of the impersonation token.
    # @return [Gitlab::ObjectifiedHash]
    def revoke_user_impersonation_token(user_id, impersonation_token_id)
      delete("/users/#{user_id}/impersonation_tokens/#{impersonation_token_id}")
    end
  end
end
