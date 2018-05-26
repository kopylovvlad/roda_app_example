# frozen_string_literal: true

module BookmarkApp
  include PaginationHandler

  def self.included(base)
    base.class_eval do
      route 'bookmarks' do |r|
        env['warden'].authenticate!

        r.is do
          # index my bookmarks
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
          r.post do
            user = User.find(r.params['user_id'])
            r.halt(404) unless user.present?

            answer = CreateBookmarkService
                     .new(env['warden'].user, user)
                     .perform
            if answer.success?
              { success: true, bookmark: answer.item }
            else
              { success: false, errors: answer.errors }
            end
          end
        end

        r.on :id do |bookmark_id|
          @bookmark = env['warden'].user.bookmarks.find(bookmark_id)
          r.halt(404) unless @bookmark.present?

          # show own bookmark
          r.get do
            { success: true, bookmark: @bookmark }
          end

          # delete a bookmark
          r.delete do
            @bookmark.destroy
            { success: true }
          end
        end
      end
    end
  end
end
