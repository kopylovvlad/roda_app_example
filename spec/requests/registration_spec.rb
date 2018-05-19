# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Registration', type: :request do
  describe 'invalid' do
    it 'should return json with errors' do
      post(
        '/registration',
        {}
      )
      expect(response.code).to eq('400')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(false)
      expect(json['errors'].keys.size).to be > 0
    end
  end

  describe 'valid' do
    it 'should create user' do
      user_count = User.count
      post(
        '/registration',
        {
          email: Faker::Internet.free_email,
          first_name: 'ivan',
          last_name: 'ivanov',
          password_confirmation: 'foofoofoo',
          password: 'foofoofoo',
        }
      )
      expect(response.code).to eq('201')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(true)
      expect(json['user']).to_not eq(nil)
      expect(User.count).to eq(user_count + 1)
    end
  end
end
