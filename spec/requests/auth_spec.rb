# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Auth', type: :request do
  describe 'full auth-case' do
    it 'works' do
      # prepare data
      email = Faker::Internet.free_email
      passw = 'foofoof'
      user = User.new(
        email: email
      )
      user.password = passw
      user.password_confirmation = passw
      user.save!
      expect(User.count).to eq(1)

      # check null session
      get('/sessions')
      expect(response.code).to eq('200')
      expect(response.content_type).to eq('application/json')
      expect(json['user']).to eq(nil)

      # create session
      post(
        '/sessions',
        email: email,
        password: passw
      )
      expect(response.code).to eq('201')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(true)
      expect(json['user']['_id']['$oid'].present?).to eq(true)
      user_id = json['user']['_id']['$oid']

      # check existing session
      get('/sessions')
      expect(response.code).to eq('200')
      expect(response.content_type).to eq('application/json')
      expect(json['user'].present?).to eq(true)
      expect(json['user']['_id']['$oid']).to eq(user_id)

      # delete session
      delete('/sessions')
      expect(response.code).to eq('200')
      expect(response.content_type).to eq('application/json')

      # check null session
      get('/sessions')
      expect(response.code).to eq('200')
      expect(response.content_type).to eq('application/json')
      expect(json['user']).to eq(nil)
    end
  end
end
