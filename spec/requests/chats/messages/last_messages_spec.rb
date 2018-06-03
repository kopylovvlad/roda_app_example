# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Last Chat::Messags', type: :request do
  include_examples 'not_guest', '/chats/12/messages/last', {}

  it 'should return last message' do
    # prepare
    user1 = FactoryBot.create(:active_user)
    user2 = FactoryBot.create(:active_user)
    chat = Chat.create!(
      user1_id: user1.id.to_s,
      user2_id: user2.id.to_s,
    )
    3.times do |i|
      Messages::CreatingService
        .new(chat, user1.id.to_s, "message ##{i}")
        .perform
    end
    sign_in(user1)

    # action
    get("/chats/#{user2.id.to_s}/messages/last")

    # check
    check_response
    expect(json['success']).to eq(true)
    expect(json['message']['text']).to eq('message #2')
  end

  describe 'chat is not exist' do
    it 'should return 404' do
      # prepare
      user1 = FactoryBot.create(:active_user)
      expect(Chat.find('999')).to eq(nil)
      sign_in(user1)

      # action
      get('/chats/999/messages/last')

      # check
      expect(response.code).to eq('404')
      expect(response.content_type).to eq('application/json')
    end
  end

  describe 'chat is empty' do
    it 'should return nil' do
      # prepare
      user1 = FactoryBot.create(:active_user)
      user2 = FactoryBot.create(:active_user)
      Chat.create!(
        user1_id: user1.id.to_s,
        user2_id: user2.id.to_s,
      )
      sign_in(user1)

      # action
      get("/chats/#{user2.id.to_s}/messages/last")

      # check
      check_response
      expect(json['success']).to eq(true)
      expect(json['message']).to eq(nil)
    end
  end
end
