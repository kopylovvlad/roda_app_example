# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Show Bookmark', type: :request do
  include_examples 'not_guest', '/bookmarks/9298323', {}
  describe 'auth user' do
    it 'should render bookmark' do
      # prepare
      user = FactoryBot.create(:active_user)
      answer = CreateBookmarkService
               .new(user, FactoryBot.create(:active_user))
               .perform
      item_id = answer.item.id.to_s

      # action
      sign_in(user)
      get("/bookmarks/#{item_id}")

      # check
      expect(response.code).to eq('200')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(true)
      expect(json['bookmark']['_id']['$oid']).to eq(item_id)
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
      get("/bookmarks/#{item_id}123213")

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
      get("/bookmarks/#{item_id}")

      # check
      expect(response.code).to eq('404')
      expect(response.content_type).to eq('application/json')
    end
  end
end
