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
              chats: items,
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

        include ChatMessageApp
      end
    end
  end
end
