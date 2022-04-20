# frozen_string_literal: true

require 'roda'
require 'json'
require_relative '../services/line_bot_service'

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

          client = LineBotService.new(App.config).client

          signature = request.env['HTTP_X_LINE_SIGNATURE']
          routing.halt 400 unless client.validate_signature(body, signature)

          events = client.parse_events_from(body)
          EventService.reply(client, events)

          response.status = 200
          { message: 'success' }.to_json
        rescue StandardError => e
          puts e.full_message
        end
      end
    end
  end
end
