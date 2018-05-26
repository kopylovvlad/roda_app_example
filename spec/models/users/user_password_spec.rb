require 'spec_helper'

RSpec.describe 'User password', type: :model do
  it 'should save password' do
    user = FactoryBot.build(
      :user,
      email: Faker::Internet.free_email
    )
    user.password = 'foofoo'
    user.password_confirmation = 'bar'
    expect(user.valid?).to eq(false)

    user.password_confirmation = 'foofoo'
    expect(user.valid?).to eq(true)
  end
end
