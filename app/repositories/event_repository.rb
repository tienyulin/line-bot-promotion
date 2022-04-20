# frozen_string_literal: true

# require_relative 'line_bot_service'

module TienYuBot
  # Line Event Repository
  class EventRepository
    # Reply message to Line client
    def self.reply(client, reply_token, message)
      client.reply_message(reply_token, message)
    end
  end
end
