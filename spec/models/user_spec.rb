require 'spec_helper'

RSpec.describe 'User', type: :model do
  describe 'password case' do
    it 'should save password' do
      user = User.new(
        email: Faker::Internet.free_email
      )
      user.password = 'foofoo'
      user.password_confirmation = 'bar'
      expect(user.valid?).to eq(false)

      user.password_confirmation = 'foofoo'
      expect(user.valid?).to eq(true)
    end

    it 'should auth user' do
      user1 = User.create!(
        email: Faker::Internet.free_email,
        password: 'foofoo',
        password_confirmation: 'foofoo'
      )
      user2 = User.create!(
        email: Faker::Internet.free_email,
        password: 'barbar',
        password_confirmation: 'barbar'
      )

      expect(user1.authenticate('barbar')).to eq(nil)
      expect(user1.authenticate('123123123')).to eq(nil)
      expect(user1.authenticate('foofoo')).to eq(user1)

      expect(user2.authenticate('foofoo')).to eq(nil)
      expect(user1.authenticate('123123123')).to eq(nil)
      expect(user2.authenticate('barbar')).to eq(user2)

      user1.destroy
      user2.destroy
    end
  end
end