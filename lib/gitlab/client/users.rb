# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to users.
  # @see https://docs.gitlab.com/ce/api/users.html
  # @see https://docs.gitlab.com/ce/api/session.html
  module Users
    # Gets a list of users.
    #
    # @example
    #   Gitlab::Client.users
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::Client::ObjectifiedHash>]
    def users(options = {})
      get('/users', query: options)
    end

    # Gets information about a user.
    # Will return information about an authorized user if no ID passed.
    #
    # @example
    #   Gitlab::Client.user
    #   Gitlab::Client.user(2)
    #
    # @param  [Integer] id The ID of a user.
    # @return [Gitlab::Client::ObjectifiedHash]
    def user(id = nil)
      id.to_i.zero? ? get('/user') : get("/users/#{id}")
    end

    # Creates a new user.
    # Requires authentication from an admin account.
    #
    # @example
    #   Gitlab::Client.create_user('joe@foo.org', 'secret', 'joe', { name: 'Joe Smith' })
    #   or
    #   Gitlab::Client.create_user('joe@foo.org', 'secret', 'joe')
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
    # @return [Gitlab::Client::ObjectifiedHash] Information about created user.
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
    #   Gitlab::Client.edit_user(15, { email: 'joe.smith@foo.org', projects_limit: 20 })
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
    # @return [Gitlab::Client::ObjectifiedHash] Information about created user.
    def edit_user(user_id, options = {})
      put("/users/#{user_id}", body: options)
    end

    # Deletes a user.
    #
    # @example
    #   Gitlab::Client.delete_user(1)
    #
    # @param [Integer] id The ID of a user.
    # @return [Gitlab::Client::ObjectifiedHash] Information about deleted user.
    def delete_user(user_id)
      delete("/users/#{user_id}")
    end

    # Blocks the specified user. Available only for admin.
    #
    # @example
    #   Gitlab::Client.block_user(15)
    #
    # @param [Integer] user_id The Id of user
    # @return [Boolean] success or not
    def block_user(user_id)
      post("/users/#{user_id}/block")
    end

    # Unblocks the specified user. Available only for admin.
    #
    # @example
    #   Gitlab::Client.unblock_user(15)
    #
    # @param [Integer] user_id The Id of user
    # @return [Boolean] success or not
    def unblock_user(user_id)
      post("/users/#{user_id}/unblock")
    end

    # Creates a new user session.
    #
    # @example
    #   Gitlab::Client.session('jack@example.com', 'secret12345')
    #
    # @param  [String] email The email of a user.
    # @param  [String] password The password of a user.
    # @return [Gitlab::Client::ObjectifiedHash]
    # @note This method doesn't require private_token to be set.
    def session(email, password)
      post('/session', body: { email: email, password: password }, unauthenticated: true)
    end

    # Gets a list of user activities (for admin access only).
    #
    # @example
    #   Gitlab::Client.activities
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @option options [String] :from The start date for paginated results.
    # @return [Array<Gitlab::Client::ObjectifiedHash>]
    def activities(options = {})
      get('/user/activities', query: options)
    end

    # Gets a list of user's SSH keys.
    #
    # @example
    #   Gitlab::Client.ssh_keys
    #   Gitlab::Client.ssh_keys({ user_id: 2 })
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @option options [Integer] :user_id The ID of the user to retrieve the keys for.
    # @return [Array<Gitlab::Client::ObjectifiedHash>]
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
    #   Gitlab::Client.ssh_key(1)
    #
    # @param  [Integer] id The ID of a user's SSH key.
    # @return [Gitlab::Client::ObjectifiedHash]
    def ssh_key(id)
      get("/user/keys/#{id}")
    end

    # Creates a new SSH key.
    #
    # @example
    #   Gitlab::Client.create_ssh_key('key title', 'key body')
    #
    # @param  [String] title The title of an SSH key.
    # @param  [String] key The SSH key body.
    # @param  [Hash] options A customizable set of options.
    # @option options  [Integer] :user_id id of the user to associate the key with
    # @return [Gitlab::Client::ObjectifiedHash] Information about created SSH key.
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
    #   Gitlab::Client.delete_ssh_key(1)
    #
    # @param  [Integer] id The ID of a user's SSH key.
    # @param  [Hash] options A customizable set of options.
    # @option options  [Integer] :user_id id of the user to associate the key with
    # @return [Gitlab::Client::ObjectifiedHash] Information about deleted SSH key.
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
    #   Gitlab::Client.emails
    #   Gitlab::Client.emails(2)
    #
    # @param  [Integer] user_id The ID of a user.
    # @return [Gitlab::Client::ObjectifiedHash]
    def emails(user_id = nil)
      url = user_id.to_i.zero? ? '/user/emails' : "/users/#{user_id}/emails"
      get(url)
    end

    # Get a single email.
    #
    # @example
    #   Gitlab::Client.email(3)
    #
    # @param  [Integer] id The ID of a email.
    # @return [Gitlab::Client::ObjectifiedHash]
    def email(id)
      get("/user/emails/#{id}")
    end

    # Creates a new email
    # Will create a new email an authorized user if no user ID passed.
    #
    # @example
    #   Gitlab::Client.add_email('email@example.com')
    #   Gitlab::Client.add_email('email@example.com', 2)
    #
    # @param  [String] email Email address
    # @param  [Integer] user_id The ID of a user.
    # @param  [Boolean] skip_confirmation     Skip confirmation and assume e-mail is verified
    # @return [Gitlab::Client::ObjectifiedHash]
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
    #   Gitlab::Client.delete_email(2)
    #   Gitlab::Client.delete_email(3, 2)
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
    #   Gitlab::Client.user_search('gitlab')
    #
    # @param  [String] search A string to search for in user names and paths.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :per_page Number of user to return per page
    # @option options [String] :page The page to retrieve
    # @return [Array<Gitlab::Client::ObjectifiedHash>]
    def user_search(search, options = {})
      options[:search] = search
      get('/users', query: options)
    end

    # Gets user custom_attributes.
    #
    # @example
    #   Gitlab::Client.user_custom_attributes(2)
    #
    # @param  [Integer] user_id The ID of a user.
    # @return [Gitlab::Client::ObjectifiedHash]
    def user_custom_attributes(user_id)
      get("/users/#{user_id}/custom_attributes")
    end

    # Gets single user custom_attribute.
    #
    # @example
    #   Gitlab::Client.user_custom_attribute(key, 2)
    #
    # @param  [String] key The custom_attributes key
    # @param  [Integer] user_id The ID of a user.
    # @return [Gitlab::Client::ObjectifiedHash]
    def user_custom_attribute(key, user_id)
      get("/users/#{user_id}/custom_attributes/#{key}")
    end

    # Creates a new custom_attribute
    #
    # @example
    #   Gitlab::Client.add_custom_attribute('some_new_key', 'some_new_value', 2)
    #
    # @param  [String] key The custom_attributes key
    # @param  [String] value The custom_attributes value
    # @param  [Integer] user_id The ID of a user.
    # @return [Gitlab::Client::ObjectifiedHash]
    def add_user_custom_attribute(key, value, user_id)
      url = "/users/#{user_id}/custom_attributes/#{key}"
      put(url, body: { value: value })
    end

    # Delete custom_attribute
    # Will delete a custom_attribute
    #
    # @example
    #   Gitlab::Client.delete_user_custom_attribute('somekey', 2)
    #
    # @param  [String] key The custom_attribute key to delete
    # @param  [Integer] user_id The ID of a user.
    # @return [Boolean]
    def delete_user_custom_attribute(key, user_id)
      delete("/users/#{user_id}/custom_attributes/#{key}")
    end
  end
end
