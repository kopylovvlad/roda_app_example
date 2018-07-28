# frozen_string_literal: true

module BookmarkApp
  include PaginationHandler

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

  def self.included(base)
    base.class_eval do
      route 'bookmarks' do |r|
        env['warden'].authenticate!

        r.is do
          # index my bookmarks
          # route: GET /bookmarks
          r.get do
            items = env['warden'].user.bookmarks
            items = paginate_yeild(r, items)
            {
              success: true,
              bookmarks: items,
              pagination: pagination_json(items)
            }
          end

          # create a bookmark
          # route: POST /bookmarks
          r.post do
            user = User.find(r.params['user_id'])
            r.halt(404) unless user.present?

            answer = Bookmarks::CreatingService
                     .new(env['warden'].user, user)
                     .perform
            if answer.success?
              { success: true, bookmark: answer.item }
            else
              response.status = 400
              { success: false, errors: answer.errors }
            end
          end
        end

        r.on :id do |bookmark_id|
          @bookmark = env['warden'].user.bookmarks.find(bookmark_id)
          r.halt(404) unless @bookmark.present?

          # show own bookmark
          # route: GET /bookmarks/:id
          r.get do
            { success: true, bookmark: @bookmark }
          end

          # delete a bookmark
          # route: DELETE /bookmarks/:id
          r.delete do
            @bookmark.destroy
            { success: true }
          end
        end
      end
    end
  end
end
