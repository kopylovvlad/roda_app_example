# frozen_string_literal: true

##
# model users
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: 'users'

  field :first_name, type: String
  field :last_name,  type: String
  field :encrypted_password, type: String
  field :height, type: Integer
  field :weight, type: Integer
  field :gender, type: String
  field :city, type: String
  field :birthdate, type: Date

  private

  def validate_gender
    self.gender = gender.downcase

    return if %w[male female].include?(gender)
    errors.add(:gender, "must be 'male' or 'female'")
  end
end
