# frozen_string_literal: true

module ChatAppDoc
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
end
