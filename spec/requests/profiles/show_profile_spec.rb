# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Show Profile', type: :request do
  describe 'guest' do
    it 'return 401' do
      # prepare
      expect(User.find(999)).to eq(nil)

      # action
      get('/profiles/999')

      # check
      expect(response.code).to eq('401')
      expect(response.content_type).to eq('application/json')
      expect(json['error']).to eq('Unauthorized')
    end
  end

  describe 'auth user' do
    it 'return 404 unless user exist' do
      # prepare
      expect(User.find(999)).to eq(nil)
      sign_in(FactoryBot.create(:user))

      # action
      get('/profiles/999')

      # check
      expect(response.code).to eq('404')
      expect(response.content_type).to eq('application/json')
      expect(json).to eq({})
    end

    it 'return existing user' do
      # prepare
      test_user = FactoryBot.create(:user)
      user_id = test_user.id.to_s
      sign_in(FactoryBot.create(:user))

      # action
      get("/profiles/#{user_id}")

      # check
      expect(response.code).to eq('200')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(true)
      expect(json['user']['_id']['$oid']).to eq(user_id)
    end
  end
end
