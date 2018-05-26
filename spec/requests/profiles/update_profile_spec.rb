# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Update Profile', type: :request do
  describe 'auth user' do
    it 'can update own profile' do
      # prepare
      user = FactoryBot.create(:user)
      sign_in(user)

      # action
      patch(
        "/profiles/#{user.id.to_s}",
        {
          city: 'Manchester'
        }
      )

      # check
      expect(response.code).to eq('200')
      expect(response.content_type).to eq('application/json')
      expect(json['user']['city']).to eq('Manchester')
      expect(User.find(user.id.to_s).city).to eq('Manchester')
    end

    it 'can get 405 and error' do
      # prepare
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      sign_in(user1)

      # action
      patch(
        "/profiles/#{user2.id.to_s}",
        {
          city: 'Manchester'
        }
      )

      # check
      expect(response.code).to eq('405')
      expect(response.content_type).to eq('application/json')
      expect(json).to eq({})
    end
  end
end
