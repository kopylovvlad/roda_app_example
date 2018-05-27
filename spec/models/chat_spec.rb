require 'spec_helper'

RSpec.describe 'Chat', type: :model do
  describe 'messages' do
    it 'should has right order' do
      id1 = '123123'
      chat = Chat.create!(
        user1_id: id1,
        user2_id: '123123sdfsdf'
      )

      chat.messages.create!(to_user_id: id1, text: '1')
      sleep 1
      chat.messages.create!(to_user_id: id1, text: '2')
      sleep 1
      chat.messages.create!(to_user_id: id1, text: '3')

      expect(chat.messages.ordered.map(&:text)).to eq(['3', '2', '1'])
      expect(chat.messages.ordered.pluck(:text)).to eq(['3', '2', '1'])
      expect(chat.messages.ordered.first.text).to eq('3')
    end
  end

  describe 'validate' do
    it 'should have different ids' do
      chat = Chat.new(user1_id: '123123', user2_id: '123123')

      expect(chat.valid?).to eq(false)
      expect(chat.save).to eq(false)

      chat.user2_id = 'asddf'

      expect(chat.valid?).to eq(true)
      expect(chat.save).to eq(true)
    end

    it 'should be uniq' do
      user1_id = 'user1_id'
      user2_id = 'user2_id'
      user3_id = 'user3_id'

      chat1 = Chat.new(
        user1_id: user1_id,
        user2_id: user2_id
      )
      chat2 = Chat.new(
        user1_id: user3_id,
        user2_id: user1_id
      )
      chat3 = Chat.new(
        user1_id: user2_id,
        user2_id: user1_id
      )

      expect(chat1.valid?).to eq(true)
      expect(chat1.save).to eq(true)

      expect(chat2.valid?).to eq(true)
      expect(chat2.save).to eq(true)

      expect(chat3.valid?).to eq(false)
      expect(chat3.save).to eq(false)
    end
  end

  describe '.get_all_for_user' do
    it 'takes chats for an user' do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      user3 = FactoryBot.create(:user)
      user4 = FactoryBot.create(:user)

      chat1 = Chat.create!(
        user1_id: user1.id.to_s,
        user2_id: user2.id.to_s,
      )
      chat2 = Chat.create!(
        user1_id: user3.id.to_s,
        user2_id: user1.id.to_s,
      )
      chat3 = Chat.create!(
        user1_id: user1.id.to_s,
        user2_id: user4.id.to_s,
      )
      Chat.create!(
        user1_id: user3.id.to_s,
        user2_id: user4.id.to_s,
      )
      Chat.create!(
        user1_id: user3.id.to_s,
        user2_id: user2.id.to_s,
      )

      user1_chats = Chat.get_all_for_user(user1.id.to_s)
      expect(user1_chats.count).to eq(3)
      expect(user1_chats).to include(chat1)
      expect(user1_chats).to include(chat2)
      expect(user1_chats).to include(chat3)
    end
  end
end
