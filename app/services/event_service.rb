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
              text: 'Hi I am Tony. Please click the menu, I will show you myself.'
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
            message = filter_message(event.message['text'])

            user_id = event['source']['userId']
            EventRepository.push_message(client, user_id, message)
          end
        end
      end
    end

    private
    def self.filter_message(text)
      message_file = nil

      if text.include?('introduce')
        message_file = File.read('app/sources/message/introduction.json')
      elsif text.include?('working experience')
        message_file = File.read('app/sources/message/work.json')
      elsif text.include?('school')
        message_file = File.read('app/sources/message/education.json')
      elsif text.include?('projects')
        message_file = File.read('app/sources/message/projects.json')
      elsif text.include?('ability')
        message_file = File.read('app/sources/message/skills.json')
      elsif text.include?('personalities')
        message_file = File.read('app/sources/message/personality.json')
      else
        return { type: 'text', text: 'Hi I am Tony. Please click the menu, I will show you myself.' }
      end

      JSON.parse(message_file)
    end
  end
end
