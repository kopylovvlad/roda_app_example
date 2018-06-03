require 'spec_helper'

RSpec.describe 'Messages::CreatingService', type: :model do
  it 'should create an message' do
    # prepate
    user1 = FactoryBot.create(:active_user)
    user2 = FactoryBot.create(:active_user)
    chat = Chat.create!(user1_id: user1.id, user2_id: user2.id)
    m_count = chat.messages.count

    # action
    answer = Messages::CreatingService
             .new(chat, user1.id.to_s, 'hello!')
             .perform

    # check
    expect(answer).to be_instance_of(::ServiceAnswer)
    expect(answer.success?).to eq(true)
    expect(answer.item).to be_instance_of(Message)
    message = answer.item
    expect(message.to_user_id).to eq(user2.id.to_s)
    expect(message.text).to eq('hello!')
    expect(message.viewed).to eq(false)
    expect(chat.messages.count).to eq(m_count + 1)
  end

  it 'should an error if message is not valid' do
    # prepate
    user1 = FactoryBot.create(:active_user)
    user2 = FactoryBot.create(:active_user)
    chat = Chat.create!(user1_id: user1.id, user2_id: user2.id)

    # action
    answer = Messages::CreatingService
             .new(chat, user1.id, nil)
             .perform

    # check
    expect(answer).to be_instance_of(::ServiceAnswer)
    expect(answer.success?).to eq(false)
    expect(answer.item).to eq(nil)
  end

  it 'should return an error if chat is nil' do
    # prepate
    user1 = FactoryBot.create(:active_user)
    user2 = FactoryBot.create(:active_user)
    chat = Chat.create!(user1_id: user1.id, user2_id: user2.id)

    # action
    answer = Messages::CreatingService
             .new(nil, user1.id, 'hello!')
             .perform

    # check
    expect(answer).to be_instance_of(::ServiceAnswer)
    expect(answer.success?).to eq(false)
    expect(answer.item).to eq(nil)
    expect(answer.errors.keys).to eq([:chat])
    expect(answer.errors[:chat]).to eq('must exist')
  end

  it 'should return an error if current_user_id is nil' do
    # prepate
    user1 = FactoryBot.create(:active_user)
    user2 = FactoryBot.create(:active_user)
    chat = Chat.create!(user1_id: user1.id, user2_id: user2.id)

    # action
    answer = Messages::CreatingService
             .new(chat, nil, 'hello!')
             .perform

    # check
    expect(answer).to be_instance_of(::ServiceAnswer)
    expect(answer.success?).to eq(false)
    expect(answer.item).to eq(nil)
    expect(answer.errors.keys).to eq([:current_user_id])
    expect(answer.errors[:current_user_id]).to eq('must exist')
  end
end
