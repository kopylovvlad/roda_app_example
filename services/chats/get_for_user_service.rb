# frozen_string_literal: true

module Chats
  module GetForUserService
    def self.perform(user_id)
      Chat.where('$or' => [{ user1_id: user_id }, { user2_id: user_id }])
    end
  end
end
