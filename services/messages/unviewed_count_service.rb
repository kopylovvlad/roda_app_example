# frozen_string_literal: true

module Messages
  module UnviewedCountService
    def self.perform(chat, current_user_id)
      chat
        .messages
        .where(to_user_id: current_user_id, viewed: false)
        .count
    end
  end
end
