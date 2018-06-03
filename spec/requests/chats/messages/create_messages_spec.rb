# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Create Chat::Messags', type: :request do
  it 'should create a message' do
    # prepare
    user1 = FactoryBot.create(:active_user)
    user2 = FactoryBot.create(:active_user)
    chat = Chat.create!(
      user1_id: user1.id.to_s,
      user2_id: user2.id.to_s,
    )
    2.times do |i|
      Messages::CreatingService
        .new(chat, user1.id.to_s, "text: #{i}")
        .perform
    end
    expect(chat.messages.count).to eq(2)
    sign_in(user1)

    # action
    post(
      "/chats/#{user2.id.to_s}/messages",
      text: 'some text'
    )

    # check
    check_response
    expect(json['success']).to eq(true)
    expect(json['message']['text']).to eq('some text')
    expect(Chat.find(chat.id.to_s).messages.count).to eq(3)
  end

  describe 'chat is not exist' do
    it 'should return 404' do
      # prepare
      user1 = FactoryBot.create(:active_user)
      expect(Chat.all.count).to eq(0)
      sign_in(user1)

      # action
      post(
        "/chats/9999/messages",
        text: 'some text'
      )

      # check
      expect(response.code).to eq('404')
      expect(response.content_type).to eq('application/json')
    end
  end

  describe 'message is not valid' do
    it 'should return an error' do
      # prepare
      user1 = FactoryBot.create(:active_user)
      user2 = FactoryBot.create(:active_user)
      chat = Chat.create!(
        user1_id: user1.id.to_s,
        user2_id: user2.id.to_s,
      )
      2.times do |i|
        Messages::CreatingService
          .new(chat, user1.id.to_s, "text: #{i}")
          .perform
      end
      expect(chat.messages.count).to eq(2)
      sign_in(user1)

      # action
      post(
        "/chats/#{user2.id.to_s}/messages",
        text: ''
      )

      # check
      check_response
      expect(json['success']).to eq(false)
      expect(json['errors'].keys.size).to be > 0
      expect(Chat.find(chat.id.to_s).messages.count).to eq(2)
    end
  end
end
