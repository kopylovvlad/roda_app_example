# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Index Chat', type: :request do
  include_examples 'not_guest', '/chats', {}

  it 'should return chats for current user' do
    user1 = FactoryBot.create(:active_user)
    user2 = FactoryBot.create(:active_user)
    user3 = FactoryBot.create(:active_user)

    chat1 = Chat.create!(
      user1_id: user1.id.to_s,
      user2_id: user2.id.to_s,
    )
    chat2 = Chat.create!(
      user1_id: user1.id.to_s,
      user2_id: user3.id.to_s,
    )
    Chat.create!(
      user1_id: user3.id.to_s,
      user2_id: user2.id.to_s,
    )
    expect(Chat.all.count).to eq(3)
    sign_in(user1)

    # action
    get('/chats')

    # check
    expect(response.code).to eq('200')
    expect(response.content_type).to eq('application/json')
    expect(json['success']).to eq(true)
    expect(json['chats'].size).to eq(2)
    expect(json['pagination'].present?).to eq(true)
    json['chats'].each do |chat_obj|
      expect([chat1.id.to_s, chat2.id.to_s]).to include(chat_obj['_id']['$oid'])
    end
  end

  describe 'user has not chats' do
    it 'should return empty array' do
      user1 = FactoryBot.create(:active_user)
      expect(Chat.all.count).to eq(0)
      sign_in(user1)

      # action
      get('/chats')

      # check
      expect(response.code).to eq('200')
      expect(response.content_type).to eq('application/json')
      expect(json['success']).to eq(true)
      expect(json['chats'].size).to eq(0)
    end
  end
end
