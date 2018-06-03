# frozen_string_literal: true

module Messages
  class CreatingService
    def initialize(chat = nil, current_user_id = nil, text = '')
      @chat = chat
      @current_user_id = current_user_id
      @text = text
    end

    def perform
      check_args || create_message
    end

    private

    def check_args
      return false unless @chat.nil? or @current_user_id.nil?
      return ServiceAnswer.new(false, nil, generate_errors)
    end

    def generate_errors
      hash = {}
      if @chat.nil?
        hash[:chat] = 'must exist'
      end
      if @current_user_id.nil?
        hash[:current_user_id] = 'must exist'
      end
      hash
    end

    def create_message
      to_user_id = init_user_id
      message = @chat
                .messages
                .new(to_user_id: to_user_id, text: @text)
      if message.valid? and message.save
        ::ServiceAnswer.new(true, message)
      else
        ::ServiceAnswer.new(false, nil, message.errors)
      end
    end

    def init_user_id
      if @chat.user1_id == @current_user_id
        @chat.user2_id
      elsif @chat.user2_id
        @chat.user1_id
      end
    end
  end
end
