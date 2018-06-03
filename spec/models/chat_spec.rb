require 'spec_helper'

RSpec.describe 'Chat', type: :model do
  describe 'messages' do
    it 'should has right order' do
      id1 = FactoryBot.create(:user).id.to_s
      chat = Chat.create!(
        user1_id: id1,
        user2_id: FactoryBot.create(:user).id.to_s
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
      id = FactoryBot.create(:user).id.to_s
      chat = Chat.new(
        user1_id: id,
        user2_id: id
      )

      expect(chat.valid?).to eq(false)
      expect(chat.save).to eq(false)

      chat.user2_id = FactoryBot.create(:user).id.to_s

      expect(chat.valid?).to eq(true)
      expect(chat.save).to eq(true)
    end

    it 'should be uniq' do
      user1_id = FactoryBot.create(:user).id.to_s
      user2_id = FactoryBot.create(:user).id.to_s
      user3_id = FactoryBot.create(:user).id.to_s

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

    it 'should check user ids' do
      chat1 = Chat.new(
        user1_id: 'fake id 1',
        user2_id: 'fake id 1'
      )

      expect(chat1.valid?).to eq(false)
      errors = chat1.errors
      expect(errors[:user1_id]).to eq(['Must be uniq', 'User must exist'])
      expect(errors[:user2_id]).to eq(['User must exist'])
      expect(chat1.save).to eq(false)
    end
  end
end
