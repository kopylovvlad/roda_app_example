# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Index Profile', type: :request do
  describe 'guest' do
    it 'return 401' do
      # action
      get('/profiles/')

      # check
      expect(response.code).to eq('401')
      expect(response.content_type).to eq('application/json')
      expect(json['error']).to eq('Unauthorized')
    end
  end

  describe 'auth user' do
    describe 'pagination' do
      it 'should return MAX_ITEMS by default' do
        # prepare
        limit = ::PaginationHandler::MAX_ITEMS + 10
        FactoryBot.create_list(
          :active_user,
          limit
        )
        expect(User.all.where(active: true).count).to eq(limit)
        sign_in(FactoryBot.create(:active_user))

        # action
        get('/profiles')

        expect(response.code).to eq('200')
        expect(response.content_type).to eq('application/json')
        expect(json['success']).to eq(true)
        expect(json['users'].size).to eq(::PaginationHandler::MAX_ITEMS)
        expect(json['pagination']).to_not eq({})
      end

      it 'should return first user' do
        # prepare
        user1 = FactoryBot.create(:active_user)
        user2 = FactoryBot.create(:active_user)
        sign_in(FactoryBot.create(:active_user))

        # action
        get(
          '/profiles',
          per_page: 1
        )

        # check
        expect(response.code).to eq('200')
        expect(response.content_type).to eq('application/json')
        expect(json['success']).to eq(true)
        expect(json['users'].size).to eq(1)
        j_user = json['users'].first
        expect(j_user['_id']['$oid']).to eq(user1.id.to_s)
        expect(json['pagination']).to_not eq({})
      end

      it 'should return last user' do
        # prepare
        user1 = FactoryBot.create(:active_user)
        user2 = FactoryBot.create(:active_user)
        sign_in(FactoryBot.create(:active_user, active: false))

        # action
        get(
          '/profiles',
          page: 2,
          per_page: 1
        )

        # check
        expect(response.code).to eq('200')
        expect(response.content_type).to eq('application/json')
        expect(json['success']).to eq(true)
        expect(json['users'].size).to eq(1)
        j_user = json['users'].first
        expect(j_user['_id']['$oid']).to eq(user2.id.to_s)
        expect(json['pagination']).to_not eq({})
      end
    end

    describe 'searching' do
      it 'should return only active users' do
        FactoryBot.create_list(
          :user,
          10,
          active: false
        )
        FactoryBot.create_list(
          :active_user,
          11,
        )
        expect(User.active.count).to eq(11)
        expect(User.inactive.count).to eq(10)
        sign_in(FactoryBot.create(:active_user, active: false))

        # action
        get('/profiles')

        expect(response.code).to eq('200')
        expect(response.content_type).to eq('application/json')
        expect(json['success']).to eq(true)
        expect(json['users'].size).to eq(11)
      end

      it 'should search' do
        FactoryBot.create(:active_user, height: 100)
        FactoryBot.create(:active_user, height: 110)
        FactoryBot.create(:active_user, height: 120)
        FactoryBot.create(:active_user, height: 130)
        expect(User.active.count).to eq(4)
        sign_in(FactoryBot.create(:active_user, active: false))

        # action
        get('/profiles', 'height_after' => 115)

        expect(response.code).to eq('200')
        expect(response.content_type).to eq('application/json')
        expect(json['success']).to eq(true)
        expect(json['users'].size).to eq(2)
      end

      it 'should search by multy-params' do
        FactoryBot.create_list(:active_user, 3)
        FactoryBot.create(
          :active_user,
          first_name: 'vladislavv',
          last_name: 'vvvvvvvv',
          email: 'vvvvvlva13@sdffg.io'
        )

        sign_in(FactoryBot.create(:active_user, active: false))

        # action
        get(
          '/profiles',
          first_name: 'vladislavv',
          last_name: 'vvvvvvvv',
          email: 'vvvvvlva13@sdffg.io'
        )

        expect(response.code).to eq('200')
        expect(response.content_type).to eq('application/json')
        expect(json['success']).to eq(true)
        expect(json['users'].size).to eq(1)
      end
    end
  end
end
