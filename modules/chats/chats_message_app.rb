# frozen_string_literal: true

module ChatsMessageApp
  include Swagger::Blocks
  swagger_path '/chats/{user_id}/messages/last' do
    parameter do
      key :name, :user_id
      key :in, :path
      key :required, true
      key :type, :integer
      key :format, :int64
    end
    operation :get do
      key :description, 'get one last message'
      key :tags, ['chats']
    end
  end
  swagger_path '/chats/{user_id}/messages/viewed' do
    parameter do
      key :name, :user_id
      key :in, :path
      key :required, true
      key :type, :integer
      key :format, :int64
    end
    operation :patch do
      key :description, 'check all messages as viewed'
      key :tags, ['chats']
    end
  end
  swagger_path '/chats/{user_id}/messages/unviewed_count' do
    parameter do
      key :name, :user_id
      key :in, :path
      key :required, true
      key :type, :integer
      key :format, :int64
    end
    operation :get do
      key :description, 'get unviewed messages count'
      key :tags, ['chats']
    end
  end
  swagger_path '/chats/{user_id}/messages' do
    parameter do
      key :name, :user_id
      key :in, :path
      key :required, true
      key :type, :integer
      key :format, :int64
    end
    operation :get do
      key :description, 'List messages'
      key :tags, ['chats']
    end
    operation :post do
      key :description, 'Create new message'
      key :tags, ['chats']
      parameter do
        key :name, :text
        key :in, :body
        key :required, true
      end
    end
  end

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
          # get one last message
          # route: GET /chats/:user_id/messages/last
          r.get do
            message = @chat.messages.ordered.first
            { success: true, message: message }
          end
        end

        r.on 'viewed' do
          # check all messages as viewed
          # route: PUT /chats/:user_id/messages/viewed
          r.put do
            Messages::ViewedService
              .perform(@chat, @current_user_id)
            { success: true }
          end
        end

        r.on 'unviewed_count' do
          # get unviewed messages count
          # route: GET /chats/:user_id/messages/unviewed_count
          r.get do
            count = Messages::UnviewedCountService
                    .perform(@chat, @current_user_id)
            { success: true, unviewed_count: count }
          end
        end

        # list messages
        # route: GET /chats/:user_id/messages
        r.get do
          messages = paginate_yeild(r, @chat.messages.ordered)
          {
            success: true,
            chat: @chat.short_json,
            messages: messages,
            pagination: pagination_json(messages)
          }
        end

        # create new message
        # route: POST /chats/:user_id/messages
        r.post do
          answer = Messages::CreatingService
                   .new(@chat, @current_user_id, r.params['text'])
                   .perform

          if answer.success?
            { success: true, message: answer.item }
          else
            response.status = 400
            { success: false, errors: answer.errors }
          end
        end
      end
    end
  end
end
