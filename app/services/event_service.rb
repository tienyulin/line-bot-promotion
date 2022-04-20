# frozen_string_literal: true

require_relative '../repositories/event_repository'

module TienYuBot
  # Line Event Service
  class EventService
    # Reply message to LINE client
    def self.reply(client, events)
      events.each do |event|
        case event.type
        when 'message'
          case event.message['type']
          when 'text'
            message = {
              type: 'text',
              text: event.message['text']
            }

            EventRepository.reply(client, event['replyToken'], message)
          end
        end
      end
    end
  end
end
