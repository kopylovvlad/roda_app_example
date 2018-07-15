# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Create Chat', type: :request do

  it 'should create a chat' do
    # prepare
    user1 = FactoryBot.create(:active_user)
    user2 = FactoryBot.create(:active_user)
    FactoryBot.create(:active_user)
    expect(Chat.all.count).to eq(0)
    sign_in(user1)

    # action
    post(
      '/chats',
      user_id: user2.id.to_s
    )

    # check
    expect(response.code).to eq('200')
    expect(response.content_type).to eq('application/json')
    expect(json['success']).to eq(true)
    chat = json['chat']
    expect(chat['user1_id']).to eq(user1.id.to_s)
    expect(chat['user2_id']).to eq(user2.id.to_s)
    expect(json['errors']).to eq({})
    expect(Chat.all.count).to eq(1)
  end

  describe 'creating without params' do
    it 'should return and error' do
      # prepare
      user1 = FactoryBot.create(:active_user)
      expect(Chat.all.count).to eq(0)
      sign_in(user1)

      # action
      post(
        '/chats',
        user_id: ''
      )

      # check
      expect(response.code).to eq('400')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(false)
      expect(json['chat']).to eq(nil)
      expect(json['errors'].keys.size).to be > 0
      expect(Chat.all.count).to eq(0)
    end
  end

  describe 'chat already exists' do
    it 'should return and error' do
      # prepare
      user1 = FactoryBot.create(:active_user)
      user2 = FactoryBot.create(:active_user)
      Chat.create!(
        user1_id: user1.id.to_s,
        user2_id: user2.id.to_s
      )
      expect(Chat.all.count).to eq(1)
      sign_in(user1)

      # action
      post(
        '/chats',
        user_id: user2.id.to_s
      )

      # check
      expect(response.code).to eq('400')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(false)
      expect(json['chat']).to eq(nil)
      errors = json['errors']
      expect(errors.keys.size).to be > 0
      expect(errors['user1_id']).to eq(['The same chat exists'])
      expect(Chat.all.count).to eq(1)
    end
  end
end
