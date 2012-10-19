class Gitlab::Client
  # Defines methods related to users.
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
      get("/users", :query => options)
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
    # @param  [String] email The email of a user.
    # @param  [String] password The password of a user.
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :name The name of a user. Defaults to email.
    # @option options [String] :skype The skype of a user.
    # @option options [String] :linkedin The linkedin of a user.
    # @option options [String] :twitter The twitter of a user.
    # @option options [Integer] :projects_limit The limit of projects for a user.
    # @return [Gitlab::ObjectifiedHash] Information about created user.
    def create_user(email, password, options={})
      body = {:email => email, :password => password, :name => email}.merge(options)
      post("/users", :body => body)
    end

    # Creates a new user session.
    #
    # @example
    #   Gitlab.session('jack@example.com', 'secret12345')
    #
    # @param  [String] email The email of a user.
    # @param  [String] password The password of a user.
    # @return [Gitlab::ObjectifiedHash]
    def session(email, password)
      post("/session", :body => {:email => email, :password => password})
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
      get("/user/keys", :query => options)
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
      post("/user/keys", :body => {:title => title, :key => key})
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
