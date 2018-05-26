# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Delete Bookmark', type: :request do
  describe 'auth user' do
    it 'should delete a bookmark' do
      # prepare
      user = FactoryBot.create(:active_user)
      answer = CreateBookmarkService
               .new(user, FactoryBot.create(:active_user))
               .perform
      item_id = answer.item.id.to_s

      # action
      sign_in(user)
      delete("/bookmarks/#{item_id}")

      # check
      expect(response.code).to eq('200')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(true)
    end

    it 'should return 404 if does not exist' do
      # prepare
      user = FactoryBot.create(:active_user)
      answer = CreateBookmarkService
               .new(user, FactoryBot.create(:active_user))
               .perform
      item_id = answer.item.id.to_s

      # action
      sign_in(user)
      delete("/bookmarks/#{item_id}123213")

      # check
      expect(response.code).to eq('404')
    end

    it 'should return 404 if another user' do
      # prepare
      user1 = FactoryBot.create(:active_user)
      CreateBookmarkService
               .new(user1, FactoryBot.create(:active_user))
               .perform
      user2 = FactoryBot.create(:active_user)
      answer = CreateBookmarkService
              .new(user2, FactoryBot.create(:active_user))
              .perform
      item_id = answer.item.id.to_s

      # action
      sign_in(user1)
      delete("/bookmarks/#{item_id}")

      # check
      expect(response.code).to eq('404')
      expect(response.content_type).to eq('application/json')
    end
  end
end
