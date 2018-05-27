require 'spec_helper'

RSpec.describe 'Users::AuthService', type: :model do
  it 'should take only User' do
    expect(Users::AuthService.perform(123, 'barbar')).to eq(false)
    expect(Users::AuthService.perform(nil, 'barbar')).to eq(false)
  end

  it 'should auth user' do
    user1 = FactoryBot.create(
      :user,
      email: Faker::Internet.free_email,
      password: 'foofoo',
      password_confirmation: 'foofoo'
    )
    user2 = FactoryBot.create(
      :user,
      email: Faker::Internet.free_email,
      password: 'barbar',
      password_confirmation: 'barbar'
    )

    expect(Users::AuthService.perform(user1, 'barbar')).to eq(false)
    expect(Users::AuthService.perform(user1, '123123123')).to eq(false)
    expect(Users::AuthService.perform(user1, 'foofoo')).to eq(true)

    expect(Users::AuthService.perform(user2, 'foofoo')).to eq(false)
    expect(Users::AuthService.perform(user1, '123123123')).to eq(false)
    expect(Users::AuthService.perform(user2, 'barbar')).to eq(true)
  end
end
