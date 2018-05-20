require 'spec_helper'

RSpec.describe 'User#search', type: :model do
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
  end

  before(:each) { create_data }

  it 'search by :active' do
    count = User.search.count
    expect(User.inactive.count).to be > 0
    expect(count).to be > 0
    expect(count).to eq(User.active.count)
  end

  it 'search by :first_name' do
    expect(User.search('first_name' => 'vladislavv').count).to eq(1)
    expect(User.search('first_name' => 'vladislavv').first.first_name).to eq('vladislavv')
  end

  it 'search by :last_name' do
    expect(User.search('last_name' => 'vvvvvvvv').count).to eq(1)
    expect(User.search('last_name' => 'vvvvvvvv').first.last_name).to eq('vvvvvvvv')
  end

  it 'search by :email' do
    expect(User.search('email' => 'vvvvvlva13@sdffg.io').count).to eq(1)
    expect(User.search('email' => 'vvvvvlva13@sdffg.io').first.email).to eq('vvvvvlva13@sdffg.io')
  end

  it 'search by :city' do
    count = User.search('city' => 'Madrid').count
    expect(count).to eq(3)
    User.search('city' => 'Madrid').each do |u|
      expect(u.city).to eq('Madrid')
    end
  end

  it 'search by :gender' do
    count1 = User.search('gender' => 'male').count
    expect(count1).to be > 1
    expect(count1).to eq(User.active.male.count)

    count2 = User.search('gender' => 'female').count
    expect(count2).to be > 1
    expect(count2).to eq(User.active.female.count)
  end

  it 'search by :height_from'
  it 'search by :height_to'

  it 'search by :weight_from'
  it 'search by :weight_to'

  it 'search by :birthdate_before'
  it 'search by :birthdate_after'

  it 'works with multy params'
end
