# frozen_string_literal: true

module TienYuBot
  # Line Event Repository
  class EventRepository
    # Reply message to Line client
    def self.reply_message(client, reply_token, message)
      client.reply_message(reply_token, message)
    end

    # Push message to Line client
    def self.push_message(client, user_id, message)
      client.push_message(user_id, message)
    end
  end
end
