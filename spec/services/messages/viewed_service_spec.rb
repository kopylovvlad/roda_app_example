# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Messages::ViewedService', type: :model do
  it 'should set all messages for current user as viewed' do
    # prepare
    user1 = FactoryBot.create(:active_user)
    user2 = FactoryBot.create(:active_user)
    chat = Chat.create!(
      user1_id: user1.id.to_s,
      user2_id: user2.id.to_s,
    )
    3.times do |i|
      Messages::CreatingService
        .new(chat, user1.id.to_s, "message for user2")
        .perform
    end
    6.times do |i|
      Messages::CreatingService
        .new(chat, user2.id.to_s, "message for user1")
        .perform
    end
    expect(chat.messages.map(&:viewed).uniq).to eq([false])

    Messages::ViewedService
      .perform(chat, user1.id.to_s)

    messages = Chat.find(chat.id.to_s).messages
    expect(messages.count).to eq(9)
    messages.each do |item|
      if item.text == "message for user1"
        expect(item.viewed).to eq(true)
      else
        expect(item.viewed).to eq(false)
      end
    end
  end

  describe 'chat has not messages' do
    it 'just work' do
      # prepare
      user1 = FactoryBot.create(:active_user)
      user2 = FactoryBot.create(:active_user)
      chat = Chat.create!(
        user1_id: user1.id.to_s,
        user2_id: user2.id.to_s,
      )

      Messages::ViewedService
        .perform(chat, user1.id.to_s)

      messages = Chat.find(chat.id.to_s).messages
      expect(messages.count).to eq(0)
    end
  end
end
