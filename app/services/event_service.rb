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
              text: '您好，我是林天佑，請透過下方選單進行點選，我將向您介紹關於我的經歷和能力。'
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
      case text
      when text.include?('自我介紹')
        message_file = File.read('app/sources/message/introduction.json')
      when text.include?('工作經驗')
        message_file = File.read('app/sources/message/work.json')
      when text.include?('大學')
        message_file = File.read('app/sources/message/education.json')
      when text.include?('專案')
        message_file = File.read('app/sources/message/projects.json')
      when text.include?('能力')
        message_file = File.read('app/sources/message/skills.json')
      when text.include?('人格特質')
        message_file = File.read('app/sources/message/personality.json')
      else
        return { type: 'text', text: '您好，我是林天佑，請透過下方選單進行點選，我將向您介紹關於我的經歷和能力。' }
      end

      JSON.parse(message_file)
    end
  end
end
