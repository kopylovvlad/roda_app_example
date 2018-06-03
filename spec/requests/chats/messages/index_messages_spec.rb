# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Index Chat::Messags', type: :request do
  include_examples 'not_guest', '/chats/12/messages', {}

  it 'should return messages with pagination' do
    ##
    # create 2 chats
    # get messages for first chat
    #
    # prepare
    user1 = FactoryBot.create(:active_user)
    user2 = FactoryBot.create(:active_user)
    user3 = FactoryBot.create(:active_user)
    chat1 = Chat.create!(
      user1_id: user1.id.to_s,
      user2_id: user2.id.to_s
    )
    10.times do |i|
      Messages::CreatingService
        .new(chat1, user1.id.to_s, "text: #{i}")
        .perform
    end
    chat2 = Chat.create!(
      user1_id: user1.id.to_s,
      user2_id: user3.id.to_s
    )
    5.times do |i|
      Messages::CreatingService
        .new(chat2, user1.id.to_s, "text: #{i}")
        .perform
    end
    sign_in(user1)

    # action
    get("/chats/#{user2.id.to_s}/messages")

    # check
    check_response
    expect(json['success']).to eq(true)
    expect(json['chat']['_id']['$oid']).to eq(chat1.id.to_s)
    expect(json['messages'].size).to eq(10)
    expect(json['pagination'].present?).to eq(true)
  end

  describe 'chat does not exist' do
    it 'should return 404' do
      # prepate
      chat = Chat.find('9999')
      expect(chat).to eq(nil)
      sign_in(FactoryBot.create(:active_user))

      # action
      get('/chats/999/messages')

      # check
      expect(response.code).to eq('404')
      expect(response.content_type).to eq('application/json')
    end
  end

  describe 'empty chat' do
    it 'should return empty array' do
      # prepare
      user1 = FactoryBot.create(:active_user)
      user2 = FactoryBot.create(:active_user)
      chat1 = Chat.create!(
        user1_id: user1.id.to_s,
        user2_id: user2.id.to_s
      )
      sign_in(user1)

      # action
      get("/chats/#{user2.id.to_s}/messages")

      # check
      check_response
      expect(json['success']).to eq(true)
      expect(json['chat']['_id']['$oid']).to eq(chat1.id.to_s)
      expect(json['messages'].size).to eq(0)
      expect(json['pagination'])
    end
  end
end
