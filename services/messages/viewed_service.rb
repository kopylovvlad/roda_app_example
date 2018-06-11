# frozen_string_literal: true

module Messages
  module ViewedService
    def self.perform(chat, current_user_id)
      chat.messages
          .where(to_user_id: current_user_id, viewed: false)
          .update_all(viewed: true)
    end
  end
end
