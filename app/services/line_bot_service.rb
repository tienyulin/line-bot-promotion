# frozen_string_literal: true

require 'line/bot'

module TienYuBot
  # Line Chatbot Service
  class LineBotService
    def initialize(app_config)
      @app_config = app_config
    end

    # Line client
    def client
      @client ||= Line::Bot::Client.new do |config|
        config.channel_id = @app_config.LINE_CHANNEL_ID
        config.channel_secret = @app_config.LINE_CHANNEL_SECRET
        config.channel_token = @app_config.LINE_CHANNEL_TOKEN
      end
    end
  end
end
