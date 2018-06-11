# frozen_string_literal: true

module ChatBaseApp
  include PaginationHandler

  def self.included(base)
    base.class_eval do
      route 'chats' do |r|
        r.is do
          r.route 'chats_app'
        end

        r.on :String do |user_id|
          r.on 'messages' do
            shared[:user_id] = user_id
            r.route 'chats_messages_app'
          end
        end
      end

      include ChatApp
      include ChatsMessageApp
    end
  end
end
