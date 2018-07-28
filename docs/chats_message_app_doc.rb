# frozen_string_literal: true

module ChatsMessageAppDoc
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
end
