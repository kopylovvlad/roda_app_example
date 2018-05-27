# frozen_string_literal: true

module Bookmarks
  class CreatingService
    def initialize(main_user = nil, another_user = nil)
      @main_user = main_user
      @another_user = another_user
    end

    def perform
      check_users || create_bookmark
    end

    private

    def check_users
      return false unless @main_user.nil? or @another_user.nil?
      return ServiceAnswer.new(false, nil, { main_user: 'must exist', another_user: 'must exist' })
    end

    def create_bookmark
      bookmark = @main_user.bookmarks.new
      bookmark.user_id = @another_user.id.to_s
      bookmark.user_name = @another_user.full_name

      if bookmark.valid? and bookmark.save
        ServiceAnswer.new(true, bookmark)
      else
        ServiceAnswer.new(false, nil, bookmark.errors)
      end
    end
  end
end
