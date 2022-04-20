# frozen_string_literal: true

require_relative '../repositories/event_repository'
require 'json'

module TienYuBot
  # Line Event Service
  class EventService
    # Reply message to LINE client
    def self.reply_message(client, events)
      events.each do |event|
        case event
        when Line::Bot::Event::Message
          case event.type
          when Line::Bot::Event::MessageType::Text
            message = {
              type: 'text',
              text: event.message['text']
            }

            EventRepository.reply_message(client, event['replyToken'], message)
          end
        end
      end
    end

    # Push message to LINE client
    def self.push_message(client, events)
      events.each do |event|
        case event
        when Line::Bot::Event::Message
          case event.type
          when Line::Bot::Event::MessageType::Text
            introduction = File.read('app/sources/message/introduction.json')
            message = JSON.parse(introduction)

            user_id = event['source']['userId']
            EventRepository.push_message(client, user_id, message)
          end
        end
      end
    end
  end
end
