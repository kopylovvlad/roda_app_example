# frozen_string_literal: true

module ChatsMessageApp
  def self.included(base)
    base.class_eval do
      route 'chats_messages_app' do |r|
        user_id = shared[:user_id]
        env['warden'].authenticate!
        @current_user_id = env['warden'].user.id.to_s
        @chat = Chats::GetByUsersService
                .perform(@current_user_id, user_id)
                .first
        r.halt(404) unless @chat.present?

        # must be before .get, .post
        r.on 'last' do
          r.get do
            # get one last message
            message = @chat.messages.ordered.first
            { success: true, message: message }
          end
        end

        r.on 'viewed' do
          r.put do
            # check all messages as viewed
            Messages::ViewedService
              .perform(@chat, @current_user_id)
            { success: true }
          end
        end

        r.on 'unviewed_count' do
          r.get do
            # get unviewed messages count
            count = Messages::UnviewedCountService
                    .perform(@chat, @current_user_id)
            { success: true, unviewed_count: count }
          end
        end

        r.get do
          # list messages
          messages = paginate_yeild(r, @chat.messages.ordered)
          {
            success: true,
            chat: @chat.short_json,
            messages: messages,
            pagination: pagination_json(messages)
          }
        end

        r.post do
          # create new message
          answer = Messages::CreatingService
                    .new(@chat, @current_user_id, r.params['text'])
                    .perform

          if answer.success?
            { success: true, message: answer.item }
          else
            { success: false, errors: answer.errors }
          end
        end
      end
    end
  end
end
