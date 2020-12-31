# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to keys.
  # @see https://docs.gitlab.com/ce/api/keys.html
  module Keys
    # Gets information about a key.
    #
    # @example
    #   Gitlab.key(1)
    #
    # @param  [Integer] id The ID of a key.
    # @return [Gitlab::ObjectifiedHash]
    def key(id)
      get("/keys/#{id}")
    end

    # Gets information about a key by key fingerprint.
    #
    # @example
    #   Gitlab.key_by_fingerprint("9f:70:33:b3:50:4d:9a:a3:ef:ea:13:9b:87:0f:7f:7e")
    #
    # @param  [String] fingerprint The Fingerprint of a key.
    # @return [Gitlab::ObjectifiedHash]
    def key_by_fingerprint(fingerprint)
      get('/keys', query: { fingerprint: fingerprint })
    end
  end
end
