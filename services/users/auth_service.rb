# frozen_string_literal: true

module Users
  module AuthService
    def self.perform(user, example_password)
      return false unless user.is_a?(User) and !user.new_record?
      b_crypt = BCrypt::Password.new(user.crypted_password)
      return b_crypt == example_password
    end
  end
end
