# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Create Bookmark', type: :request do
  describe 'auth user' do
    it 'should create bookmark' do
      # prepare
      user1 = FactoryBot.create(:active_user)
      user2 = FactoryBot.create(:active_user)

      # action
      sign_in(user1)
      post('/bookmarks', user_id: user2.id.to_s)

      # check
      expect(response.code).to eq('200')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(true)
      expect(json['bookmark']).to_not eq(nil)
    end

    it 'should return errors' do
      # prepare
      user1 = FactoryBot.create(:active_user)
      user2 = FactoryBot.create(:active_user)
      CreateBookmarkService.new(user1, user2).perform

      # action
      sign_in(user1)
      post('/bookmarks', user_id: user2.id.to_s)

      # check
      expect(response.code).to eq('200')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(false)
      expect(json['errors']).to_not eq(nil)
    end

    it 'should return 404 unless user exist' do
      # prepare
      user = FactoryBot.create(:active_user)

      # action
      sign_in(user)
      post('/bookmarks', user_id: '9999')

      # check
      expect(response.code).to eq('404')
    end
  end
end
