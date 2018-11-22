# frozen_string_literal: true

class Gitlab::Client
  # Defines methods related to broadcast messages (only accessible to administrators).
  # @see https://docs.gitlab.com/ce/api/broadcast_messages.html
  module BroadcastMessages
    # Get all broadcast messages
    #
    # @example
    #   Gitlab.broadcast_messages
    #
    # @return [Array<Gitlab::ObjectifiedHash>]
    def broadcast_messages
      get('/broadcast_messages')
    end

    # Get a specific broadcast message
    #
    # @example
    #   Gitlab.broadcast_message(3)
    #
    # @param  [Integer] id The ID of broadcast message
    # @return [Gitlab::ObjectifiedHash]
    def broadcast_message(id)
      get("/broadcast_messages/#{id}")
    end

    # Create a broadcast message.
    #
    # @example
    #   Gitlab.create_broadcast_message('Mayday')
    #   Gitlab.create_broadcast_message('Mayday', {starts_at: Time.zone.now, ends_at: Time.zone.now + 30.minutes, color: '#cecece', font: '#FFFFFF'})
    #
    # @param  [String] message Message to display
    # @param  [Hash] options A customizable set of options.
    # @option options [DateTime] :starts_at(optional) Starting time (defaults to current time)
    # @option options [DateTime] :ends_at(optional) Ending time (defaults to one hour from current time)
    # @option options [String] :color(optional) Background color hex code
    # @option options [String] :font(optional) Foreground color hex code
    # @return [Gitlab::ObjectifiedHash] Information about created broadcast message.
    def create_broadcast_message(message, options = {})
      body = { message: message }.merge(options)
      post('/broadcast_messages', body: body)
    end

    # Update a broadcast message
    #
    # @example
    #   Gitlab.edit_broadcast_message(6, { message: 'No Mayday' })
    #   Gitlab.edit_broadcast_message(6, { font: '#FEFEFE' })
    #
    # @param  [Integer] id The ID of a broadcast message
    # @param  [Hash] options A customizable set of options.
    # @option options [String] :message(optional) Message to display
    # @option options [DateTime] :starts_at(optional) Starting time (defaults to current time)
    # @option options [DateTime] :ends_at(optional) Ending time (defaults to one hour from current time)
    # @option options [String] :color(optional) Background color hex code
    # @option options [String] :font(optional) Foreground color hex code
    # @return [Gitlab::ObjectifiedHash] Information about updated broadcast message.
    def edit_broadcast_message(id, options = {})
      put("/broadcast_messages/#{id}", body: options)
    end

    # Delete a broadcast message.
    #
    # @example
    #   Gitlab.delete_broadcast_message(3)
    #
    # @param  [Integer] id The ID of a broadcast message.
    # @return [nil] This API call returns an empty response body.
    def delete_broadcast_message(id)
      delete("/broadcast_messages/#{id}")
    end
  end
end
