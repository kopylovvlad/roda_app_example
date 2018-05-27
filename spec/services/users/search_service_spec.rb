require 'spec_helper'

RSpec.describe 'Users::SearchService', type: :model do
  def create_data
    # inactive
    FactoryBot.create_list(:user, 2, active: false)

    # active
    FactoryBot.create(
      :user,
      first_name: 'vladislavv',
      last_name: 'vvvvvvvv',
      email: 'vvvvvlva13@sdffg.io',
      active: true
    )
    FactoryBot.create(
      :user,
      gender: 'male',
      active: true
    )
    FactoryBot.create(
      :user,
      gender: 'female',
      active: true
    )
    FactoryBot.create_list(
      :user,
      3,
      city: 'Madrid',
      active: true
    )

    FactoryBot.create(:user, active: true, height: 100)
    FactoryBot.create(:user, active: true, height: 110)
    FactoryBot.create(:user, active: true, height: 120)
    FactoryBot.create(:user, active: true, height: 130)

    FactoryBot.create(:user, active: true, weight: 80)
    FactoryBot.create(:user, active: true, weight: 90)
    FactoryBot.create(:user, active: true, weight: 100)
    FactoryBot.create(:user, active: true, weight: 110)

    FactoryBot.create(:user, active: true, birthdate: Date.parse('12-11-1991'))
    FactoryBot.create(:user, active: true, birthdate: Date.parse('12-11-1992'))
    FactoryBot.create(:user, active: true, birthdate: Date.parse('12-11-1993'))
    FactoryBot.create(:user, active: true, birthdate: Date.parse('12-11-1994'))
  end

  before(:each) { create_data }

  it 'search by :active' do
    expect(User.count).to eq(20)
    count = Users::SearchService.perform.count
    expect(User.inactive.count).to be > 0
    expect(count).to be > 0
    expect(count).to eq(User.active.count)
  end

  it 'search by :first_name' do
    expect(User.count).to eq(20)
    expect(Users::SearchService.perform('first_name' => 'vladislavv').count).to eq(1)
    expect(Users::SearchService.perform('first_name' => 'vladislavv').first.first_name).to eq('vladislavv')
  end

  it 'search by :last_name' do
    expect(User.count).to eq(20)
    expect(Users::SearchService.perform('last_name' => 'vvvvvvvv').count).to eq(1)
    expect(Users::SearchService.perform('last_name' => 'vvvvvvvv').first.last_name).to eq('vvvvvvvv')
  end

  it 'search by :email' do
    expect(User.count).to eq(20)
    expect(Users::SearchService.perform('email' => 'vvvvvlva13@sdffg.io').count).to eq(1)
    expect(Users::SearchService.perform('email' => 'vvvvvlva13@sdffg.io').first.email).to eq('vvvvvlva13@sdffg.io')
  end

  it 'search by :city' do
    expect(User.count).to eq(20)
    count = Users::SearchService.perform('city' => 'Madrid').count
    expect(count).to eq(3)
    Users::SearchService.perform('city' => 'Madrid').each do |u|
      expect(u.city).to eq('Madrid')
    end
  end

  it 'search by :gender' do
    expect(User.count).to eq(20)
    count1 = Users::SearchService.perform('gender' => 'male').count
    expect(count1).to be > 1
    expect(count1).to eq(User.active.male.count)

    count2 = Users::SearchService.perform('gender' => 'female').count
    expect(count2).to be > 1
    expect(count2).to eq(User.active.female.count)
  end

  it 'search by :height_after' do
    expect(User.count).to eq(20)
    users1 = Users::SearchService.perform('height_after' => 115)
    expect(users1.count).to be >= 2
    users1.each do |u|
      expect(u.height).to be > 115
    end

    users2 = Users::SearchService.perform('height_after' => 105)
    expect(users2.count).to be >= 3
    users2.each do |u|
      expect(u.height).to be > 105
    end
  end

  it 'search by :height_before' do
    expect(User.count).to eq(20)
    users1 = Users::SearchService.perform('height_before' => 120)
    expect(users1.size).to be >= 2
    users1.each do |u|
      expect(u.height).to be < 120
    end

    users2 = Users::SearchService.perform('height_before' => 110)
    expect(users2.count).to be >= 1
    users2.each do |u|
      expect(u.height).to be < 110
    end
  end

  it 'search by :weight_after' do
    expect(User.count).to eq(20)
    users1 = Users::SearchService.perform('weight_after' => 85)
    expect(users1.count).to be >= 3
    users1.each do |u|
      expect(u.weight).to be > 85
    end

    users2 = Users::SearchService.perform('weight_after' => 105)
    expect(users2.count).to be >= 1
    users2.each do |u|
      expect(u.weight).to be > 105
    end
  end

  it 'search by :weight_before' do
    expect(User.count).to eq(20)
    users1 = Users::SearchService.perform('weight_before' => 90)
    expect(users1.count).to be >= 1
    users1.each do |u|
      expect(u.weight).to be < 90
    end

    users2 = Users::SearchService.perform('weight_before' => 100)
    expect(users2.count).to be >= 2
    users2.each do |u|
      expect(u.weight).to be < 100
    end
  end

  it 'search by :birthdate_before' do
    expect(User.count).to eq(20)
    users1 = Users::SearchService.perform('birthdate_before' => '20-11-1991')
    expect(users1.count).to be >= 1
    users1.each do |u|
      expect(u.birthdate).to be < Date.parse('20-11-1991')
    end

    users2 = Users::SearchService.perform('birthdate_before' => '20-11-1993')
    expect(users2.count).to be >= 3
    users2.each do |u|
      expect(u.birthdate).to be < Date.parse('20-11-1993')
    end
  end

  it 'search by :birthdate_after' do
    expect(User.count).to eq(20)
    users1 = Users::SearchService.perform('birthdate_after' => '20-11-1991')
    expect(users1.count).to be >= 3
    users1.each do |u|
      expect(u.birthdate).to be > Date.parse('20-11-1991')
    end

    users2 = Users::SearchService.perform('birthdate_after' => '20-11-1993')
    expect(users2.count).to be >= 1
    users2.each do |u|
      expect(u.birthdate).to be > Date.parse('20-11-1993')
    end
  end

  it 'works with multy params' do
    expect(User.count).to eq(20)
    users = Users::SearchService.perform(
      'first_name' => 'vladislavv',
      'last_name' => 'vvvvvvvv',
      'email' => 'vvvvvlva13@sdffg.io'
    )
    expect(users.count).to eq(1)
    user = users.first
    expect(user.first_name).to eq('vladislavv')
    expect(user.last_name).to eq('vvvvvvvv')
    expect(user.email).to eq('vvvvvlva13@sdffg.io')
  end

  describe 'search by id' do
    it 'should return active user by id' do
      FactoryBot.create_list(:user, 2)
      FactoryBot.create_list(:active_user, 3)
      user = FactoryBot.create(
        :user,
        active: false
      )

      users = Users::SearchService.perform('id' => user.id.to_s)
      expect(users.size).to eq(0)
      users = Users::SearchService.perform('id' => [user.id.to_s])
      expect(users.size).to eq(0)

      user.update_attributes(active: true)

      users = Users::SearchService.perform('id' => user.id.to_s)
      expect(users.size).to eq(1)
      users = Users::SearchService.perform('id' => [user.id.to_s])
      expect(users.size).to eq(1)
    end

    it 'should return active users by ids' do
      FactoryBot.create_list(:user, 2)
      FactoryBot.create_list(:active_user, 3)
      user1 = FactoryBot.create(:user, active: false)
      user2 = FactoryBot.create(:user, active: false)
      ids = [user1.id.to_s, user2.id.to_s]

      users = Users::SearchService.perform('id' => ids)
      expect(users.size).to eq(0)

      user1.update_attributes(active: true)
      user2.update_attributes(active: true)

      users = Users::SearchService.perform('id' => ids)
      expect(users.size).to eq(2)
    end
  end
end
