# frozen_string_literal: true

module ChatApp
  include Swagger::Blocks
  swagger_path '/chats' do
    operation :get do
      key :description, 'Returns your own chats'
      key :tags, ['chats']
    end
    operation :post do
      key :description, 'Create new chat'
      key :tags, ['chats']
      parameter do
        key :name, :user_id
        key :in, :body
        key :required, true
      end
    end
  end

  def self.included(base)
    base.class_eval do
      route 'chats_app' do |r|
        env['warden'].authenticate!
        @current_user = env['warden'].user

        # route: GET /chats
        r.get do
          chats = Chats::GetForUserService.perform(@current_user.id.to_s)
          items = paginate_yeild(r, chats)
          {
            success: true,
            chats: items.map(&:short_json),
            pagination: pagination_json(items)
          }
        end

        # route: POST /chats
        r.post do
          another_user = User.find(r.params['user_id'])
          answer = Chats::CreatingService
                   .new(@current_user, another_user)
                   .perform

          if answer.success?
            { success: true, chat: answer.item, errors: {} }
          else
            response.status = 400
            { success: false, chat: nil, errors: answer.errors }
          end
        end
      end
    end
  end
end
