# frozen_string_literal: true

module BookmarkAppDoc
  include Swagger::Blocks
  swagger_path '/bookmarks' do
    operation :get do
      key :description, 'Returns your own bookmarks'
      key :tags, ['bookmarks']
    end
    operation :post do
      key :description, 'Create a bookmark'
      key :tags, ['bookmarks']
      parameter do
        key :name, :user_id
        key :in, :body
        key :required, true
      end
    end
  end
  swagger_path '/bookmarks/{id}' do
    operation :get do
      key :description, 'Show your own bookmark'
      key :tags, ['bookmarks']
      parameter do
        key :name, :id
        key :in, :path
        key :required, true
        key :type, :integer
        key :format, :int64
      end
    end
    operation :delete do
      key :description, 'Delete your own bookmark'
      key :tags, ['bookmarks']
      parameter do
        key :name, :id
        key :in, :path
        key :required, true
        key :type, :integer
        key :format, :int64
      end
    end
  end
end
