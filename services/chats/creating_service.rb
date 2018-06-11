# frozen_string_literal: true

module Chats
  class CreatingService
    def initialize(current_user, another_user)
      @current_user = current_user
      @another_user = another_user
    end

    def perform
      check_arg || creating
    end

    private

    def check_arg
      return false if @current_user.is_a?(User) and @another_user.is_a?(User)
      ::ServiceAnswer.new(false, nil, generate_errors)
    end

    def creating
      chat = Chat.new(user1_id: @current_user.id.to_s, user2_id: @another_user.id.to_s)
      if chat.valid? and chat.save
        ::ServiceAnswer.new(true, chat, {})
      else
        ::ServiceAnswer.new(false, nil, chat.errors)
      end
    end

    def generate_errors
      msg = 'must be instance of User'
      hash = {}
      hash[:current_user] = msg unless @current_user.is_a?(User)
      hash[:another_user] = msg unless @another_user.is_a?(User)
      hash
    end
  end
end
