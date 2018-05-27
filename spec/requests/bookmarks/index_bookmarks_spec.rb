# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Index Bookmarks', type: :request do
  include_examples 'not_guest', '/bookmarks', {}

  describe 'auth user' do
    it 'should return empty array' do
      # prepare
      user = FactoryBot.create(:active_user)
      expect(user.bookmarks.count).to eq(0)
      sign_in(FactoryBot.create(:active_user))

      # action
      get('/bookmarks')

      # check
      expect(response.code).to eq('200')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(true)
      expect(json['bookmarks']).to eq([])
      expect(json['pagination']).to_not eq({})
    end

    it 'should return only current user\'s bookmarks' do
      # prepare
      user1 = FactoryBot.create(:active_user)
      user2 = FactoryBot.create(:active_user)
      3.times do
        Bookmarks::CreatingService
          .new(user1, FactoryBot.create(:active_user))
          .perform
      end
      2.times do
        Bookmarks::CreatingService
          .new(user2, FactoryBot.create(:active_user))
          .perform
      end
      expect(user1.bookmarks.count).to eq(3)
      expect(user2.bookmarks.count).to eq(2)

      # action
      sign_in(user1)
      get('/bookmarks')

      # check
      expect(response.code).to eq('200')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(true)
      expect(json['bookmarks'].size).to eq(3)
      expect(json['pagination']).to_not eq({})
    end

    it 'should return one bookmark' do
      # prepare
      user1 = FactoryBot.create(:active_user)
      3.times do
        Bookmarks::CreatingService
          .new(user1, FactoryBot.create(:active_user))
          .perform
      end
      expect(user1.bookmarks.count).to eq(3)

      # action
      sign_in(user1)
      get('/bookmarks', { per_page: 1 })

      # check
      expect(response.code).to eq('200')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(true)
      expect(json['bookmarks'].size).to eq(1)
      expect(json['pagination']).to_not eq({})
    end
  end
end
