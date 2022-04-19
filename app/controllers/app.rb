# frozen_string_literal: true

require 'roda'
require 'json'
require 'line/bot'

module TienYuBot
  # Web App
  class App < Roda
    plugin :halt

    route do |routing|
      # GET /
      routing.root do
        message = "TienYuBot API v1 at /api/v1/ in #{App.environment} mode"

        response.status = 200
        message.to_json
      end

      routing.on 'callback' do
        routing.post do
          body = request.body.read

          client = Line::Bot::Client.new { |config|
            config.channel_id = App.config.LINE_CHANNEL_ID
            config.channel_secret = App.config.LINE_CHANNEL_SECRET
            config.channel_token = App.config.LINE_CHANNEL_TOKEN
          }

          signature = request.env['HTTP_X_LINE_SIGNATURE']
          routing.halt 400 unless client.validate_signature(body, signature)

          events = client.parse_events_from(body)
          events.each do |event|
            case event
            when Line::Bot::Event::Message
              case event.type
              when Line::Bot::Event::MessageType::Text
                message = {
                  type: 'text',
                  text: event.message['text']
                }

                client.reply_message(event['replyToken'], message)
              end
            end
          end

          response.status = 200
          { message: 'success' }.to_json
        end
      end
    end
  end
end
