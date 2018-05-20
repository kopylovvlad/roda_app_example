# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Session', type: :request do
  describe 'show current session' do
    describe 'guest' do
      it 'get nil' do
        get('/sessions')
        expect(response.code).to eq('200')
        expect(response.content_type).to eq('application/json')
        expect(json['user']).to eq(nil)
      end
    end

    describe 'auth user' do
      it 'get current profile' do
        # prepare data
        email1 = Faker::Internet.free_email
        email2 = Faker::Internet.free_email
        passw = 'foofoof'

        user1 = User.create!(
          email: email1,
          password: passw,
          password_confirmation: passw
        )
        user2 = User.create!(
          email: email2,
          password: passw,
          password_confirmation: passw
        )
        expect(User.count).to eq(2)

        sign_in(user2)

        # action
        get('/sessions')
        expect(response.code).to eq('200')
        expect(response.content_type).to eq('application/json')
        expect(json['user'].present?).to eq(true)
        expect(json['user']['_id']['$oid']).to eq(user2._id.to_s)
        expect(json['user']['_id']['$oid']).to_not eq(user1._id.to_s)
      end
    end
  end
end
