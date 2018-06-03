module UnviewedHelper
  def prepare_unviewed_coun_data
    @user1_id = FactoryBot.create(:user).id.to_s
    @user2_id = FactoryBot.create(:user).id.to_s
    @chat = Chat.create!(
      user1_id: @user1_id,
      user2_id: @user2_id
    )

    1.times do |i|
      Messages::CreatingService
        .new(@chat, @user1_id, "viewed message for user2")
        .perform
    end
    2.times do |i|
      Messages::CreatingService
        .new(@chat, @user2_id, "viewed message for user1")
        .perform
    end
    Messages::ViewedService.perform(@chat, @user1_id)
    Messages::ViewedService.perform(@chat, @user2_id)

    2.times do |i|
      Messages::CreatingService
        .new(@chat, @user1_id, "unviewed message for user2")
        .perform
    end
    3.times do |i|
      Messages::CreatingService
        .new(@chat, @user2_id, "unviewed message for user1")
        .perform
    end

    expect(@chat.messages.count).to eq(8)
  end
end
