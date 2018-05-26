# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Session', type: :request do
  describe 'show current session' do
    describe 'guest' do
      it 'get nil' do
        # action
        get('/sessions')

        # check
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
          first_name: 'test',
          last_name: 'test',
          password: passw,
          password_confirmation: passw
        )
        user2 = User.create!(
          email: email2,
          first_name: 'test',
          last_name: 'test',
          password: passw,
          password_confirmation: passw
        )
        expect(User.count).to eq(2)

        sign_in(user2)

        # action
        get('/sessions')

        # check
        expect(response.code).to eq('200')
        expect(response.content_type).to eq('application/json')
        expect(json['user'].present?).to eq(true)
        expect(json['user']['_id']['$oid']).to eq(user2._id.to_s)
        expect(json['user']['_id']['$oid']).to_not eq(user1._id.to_s)
      end
    end
  end

  describe 'create new session' do
    it 'return errors' do
      # prepare
      email = 'fakeemail@gool.ru'
      passw = 'mysecretpass'
      FactoryBot.create(
        :user,
        email: email,
        password: passw,
        password_confirmation: passw
      )

      # action
      post(
        '/sessions',
        email: email,
        password: 'sdfsdfsdf'
      )

      # check
      expect(response.code).to eq('401')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(false)
      expect(json['error']).to eq('Unauthorized')
    end

    it 'create new session' do
      # prepate
      email = 'fakeemail@gool.ru'
      passw = 'mysecretpass'
      u = FactoryBot.create(
        :user,
        email: email,
        password: passw,
        password_confirmation: passw
      )
      user_id = u.id.to_s

      # action
      post(
        '/sessions',
        email: email,
        password: passw
      )

      # check
      expect(response.code).to eq('201')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(true)
      expect(json['user']['_id']['$oid']).to eq(user_id)
    end
  end
end
