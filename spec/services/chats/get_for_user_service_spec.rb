require 'spec_helper'

RSpec.describe 'Chats::GetForUserService', type: :model do
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

    user1_chats = Chats::GetForUserService.perform(user1.id.to_s)
    expect(user1_chats.count).to eq(3)
    expect(user1_chats).to include(chat1)
    expect(user1_chats).to include(chat2)
    expect(user1_chats).to include(chat3)
  end
end
