require 'spec_helper'

RSpec.describe 'Bookmarks::CreatingService', type: :model do
  it 'should check users' do
    err_json = { main_user: 'must exist', another_user: 'must exist' }

    answer = Bookmarks::CreatingService.new.perform

    expect(answer.class).to eq(ServiceAnswer)
    expect(answer.success?).to eq(false)
    expect(answer.errors).to eq(err_json)
  end

  it 'should create bookmark' do
    # prepare
    user1 = FactoryBot.create(:active_user)
    user2 = FactoryBot.create(:active_user)
    expect(user1.bookmarks.count).to eq(0)
    expect(user2.bookmarks.count).to eq(0)

    # action
    answer = Bookmarks::CreatingService.new(user2, user1).perform

    # check
    expect(user1.bookmarks.count).to eq(0)
    expect(user2.bookmarks.count).to eq(1)
    expect(answer.class).to eq(ServiceAnswer)
    expect(answer.success?).to eq(true)
    item = answer.item
    expect(item.class).to eq(Bookmark)
    expect(item.user_id).to eq(user1.id.to_s)
    expect(item.user_name).to eq(user1.full_name)
  end

  it 'should create two bookmarks' do
    # prepare
    user1 = FactoryBot.create(:active_user)
    user2 = FactoryBot.create(:active_user)
    user3 = FactoryBot.create(:active_user)
    expect(user1.bookmarks.count).to eq(0)
    expect(user2.bookmarks.count).to eq(0)
    expect(user3.bookmarks.count).to eq(0)

    # action
    Bookmarks::CreatingService.new(user2, user1).perform
    answer = Bookmarks::CreatingService.new(user2, user3).perform

    # check
    expect(user1.bookmarks.count).to eq(0)
    expect(user2.bookmarks.count).to eq(2)
    expect(user3.bookmarks.count).to eq(0)
    expect(answer.class).to eq(ServiceAnswer)
    expect(answer.success?).to eq(true)
  end

  it 'should return bookmark errors' do
    # prepare
    user1 = FactoryBot.create(:active_user)
    user2 = FactoryBot.create(:active_user)
    expect(user1.bookmarks.count).to eq(0)
    expect(user2.bookmarks.count).to eq(0)

    # action
    Bookmarks::CreatingService.new(user2, user1).perform
    answer = Bookmarks::CreatingService.new(user2, user1).perform

    # check
    expect(user1.bookmarks.count).to eq(0)
    expect(user2.bookmarks.count).to eq(1)
    expect(answer.class).to eq(ServiceAnswer)
    expect(answer.success?).to eq(false)
  end
end
