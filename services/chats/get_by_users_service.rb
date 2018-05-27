# frozen_string_literal: true

module Chats
  module GetByUsersService
    def self.perform(user1_id, user2_id)
      Chat.where(
        '$or' => [
          { user1_id: user1_id, user2_id: user2_id },
          { user1_id: user2_id, user2_id: user1_id }
        ]
      )
    end
  end
end
