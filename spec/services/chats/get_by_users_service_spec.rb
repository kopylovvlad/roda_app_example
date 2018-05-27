require 'spec_helper'

RSpec.describe 'Chats::GetByUsersService', type: :model do
  it 'should return a chat' do
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
    Chat.create!(
      user1_id: user1.id.to_s,
      user2_id: user4.id.to_s,
    )

    # chat1
    chats = Chats::GetByUsersService.perform(user1.id.to_s, user2.id.to_s)
    expect(chats.to_a).to eq([chat1])
    chats = Chats::GetByUsersService.perform(user2.id.to_s, user1.id.to_s)
    expect(chats.to_a).to eq([chat1])

    # chat2
    chats = Chats::GetByUsersService.perform(user3.id.to_s, user1.id.to_s)
    expect(chats.to_a).to eq([chat2])
    chats = Chats::GetByUsersService.perform(user1.id.to_s, user3.id.to_s)
    expect(chats.to_a).to eq([chat2])

    # nil
    chats = Chats::GetByUsersService.perform(user2.id.to_s, user3.id.to_s)
    expect(chats.to_a).to eq([])
    chats = Chats::GetByUsersService.perform(user3.id.to_s, user2.id.to_s)
    expect(chats.to_a).to eq([])
  end
end
