FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "#{i}#{Faker::Internet.free_email}" }
    sequence(:first_name) { Faker::Name.first_name }
    sequence(:last_name) { Faker::Name.last_name }

    sequence(:height) { Faker::Number.between(150, 210) }
    sequence(:weight) { Faker::Number.between(60, 100) }
    sequence(:gender) { ['male', 'female'].sample }
    sequence(:city) { ['Moscow', 'Berlin', 'London'].sample }
    sequence(:birthdate) { Faker::Date.birthday(18, 65) }
    sequence(:active) { [true, false].sample }

    password 'sdfsdfsdf'
    password_confirmation 'sdfsdfsdf'

    factory :active_user do
      active true
    end
  end
end
