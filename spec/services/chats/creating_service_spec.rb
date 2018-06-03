# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'Chats::CreatingService', type: :model do
  let(:user1) do
    FactoryBot.create(:active_user)
  end
  let(:user2) do
    FactoryBot.create(:active_user)
  end

  it 'should create new chat' do
    chats_count = Chat.all.count

    # action
    answer = Chats::CreatingService
             .new(user1, user2)
             .perform

    # check
    expect(answer).to be_instance_of(ServiceAnswer)
    expect(answer.success?).to eq(true)
    expect(answer.item).to be_instance_of(Chat)
    expect(Chat.all.count).to eq(chats_count + 1)
  end

  it 'should return an errors' do
    # prepare
    Chat.create!(
      user1_id: user1.id.to_s,
      user2_id: user2.id.to_s
    )
    chats_count = Chat.all.count

    # action
    answer = Chats::CreatingService
             .new(user1, user2)
             .perform

    # check
    expect(answer).to be_instance_of(ServiceAnswer)
    expect(answer.success?).to eq(false)
    expect(answer.item).to eq(nil)
    expect(Chat.all.count).to eq(chats_count)
  end


  describe 'current_user does not exist' do
    it 'should return an error' do
      # action
      answer = Chats::CreatingService
               .new(nil, user2)
               .perform

      # check
      expect(answer).to be_instance_of(ServiceAnswer)
      expect(answer.success?).to eq(false)
      expect(answer.item).to eq(nil)
    end
  end

  describe 'another_user does not exist' do
    it 'should return an error' do
      # action
      answer = Chats::CreatingService
               .new(user1, nil)
               .perform

      # check
      expect(answer).to be_instance_of(ServiceAnswer)
      expect(answer.success?).to eq(false)
      expect(answer.item).to eq(nil)
    end
  end
end
