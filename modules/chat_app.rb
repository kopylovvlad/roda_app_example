# frozen_string_literal: true

module ChatApp
  include PaginationHandler

  def self.included(base)
    base.class_eval do

      route 'chats' do |r|
        env['warden'].authenticate!
        r.is do
          @current_user = env['warden'].user

          r.get do
            chats = Chats::GetForUserService.perform(@current_user.id.to_s)
            items = paginate_yeild(r, chats)
            {
              success: true,
              chats: items.map(&:short_json),
              pagination: pagination_json(items)
            }
          end

          r.post do
            another_user = User.find(r.params['user_id'])
            answer = Chats::CreatingService
                     .new(@current_user, another_user)
                     .perform

            if answer.success?
              { success: true, chat: answer.item, errors: {} }
            else
              { success: false, chat: nil, errors: answer.errors }
            end
          end
        end

        r.on :String do |user_id|
          r.is 'messages' do
            @current_user_id = env['warden'].user.id.to_s
            @chat = Chats::GetByUsersService
                    .perform(@current_user_id, user_id)
                    .first
            r.halt(404) unless @chat.present?

            r.get do
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
end
