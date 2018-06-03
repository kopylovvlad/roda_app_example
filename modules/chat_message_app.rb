# frozen_string_literal: true

# TODO: request-tests
module ChatMessageApp
  include PaginationHandler

  def self.included(base)
    base.class_eval do
      r.on :user_id do |user_id|

        r.is 'messages' do
          @current_user_id = env['warden'].user.id_to_s
          @chat = Chats::GetByUsersService
                  .perform(current_user_id, user_id)
                  .first

          r.get do
            # index chat's messages
            # TODO: test
            messages = paginate_yeild(r, @chat.messages.ordered)
            {
              success: true,
              chat: chat,
              messages: messages,
              pagination: pagination_json(items)
            }
          end

          r.post do
            # create new message
            # TODO: test
            answer = Messages::CreatingService
                     .new(@chat, @current_user_id, r.params['text'])
                     .perform

            if answer.success?
              { success: true, message: answer.item }
            else
              { success: false, errors: answer.errors }
            end
          end

          r.is 'last' do
            r.get do
              # get one last message
              # TODO: test
              message = @chat.messages.ordered.first
              { success: true, message: message }
            end
          end

          r.is 'viewed' do
            r.put do
              # check all messages as viewed
              # TODO: test
              Messages::ViewedService
                .perform(@chat, @current_user_id)
              { success: true }
            end
          end

          r.is 'unviewed_count' do
            r.get do
              # get unviewed messages count
              # TODO: test
              count = Messages::UnviewedCountService
                      .perform(@chat, @current_user_id)
              { success: true, unviewed: count }
            end
          end
        end
      end
    end
  end
end
