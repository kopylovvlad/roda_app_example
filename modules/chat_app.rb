# frozen_string_literal: true

module ChatApp
  include PaginationHandler

  def self.included(base)
    base.class_eval do
      route 'chats' do |r|
        env['warden'].authenticate!

        r.is do
          # index my chats
          # TODO: test
          r.get do
            user_id = env['warden'].user.id_to_s
            chats = Chats::GetForUserService.perform(user_id)
            items = paginate_yeild(r, chats)
            {
              success: true,
              chats: items,
              pagination: pagination_json(items)
            }
          end
        end

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
                # to service
                @chat.messages
                     .where(to_user_id: @current_user_id, viewed: false)
                     .update_all(viewed: true)
                { success: true }
              end
            end

            r.is 'unviewed' do
              r.get do
                # get unviewed messages count
                # TODO: test
                # to service
                count = @chat.messages
                       .where(to_user_id: @current_user_id, viewed: false)
                       .count
                { success: true, unviewed: count }
              end
            end
          end
        end
      end
    end
  end
end
