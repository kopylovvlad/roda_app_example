# frozen_string_literal: true
require 'warden'

Warden::Manager.serialize_into_session do |user|
  user.id.to_s.encrypt
end
Warden::Manager.serialize_from_session do |id|
  User.find(id.decrypt)
end

Warden::Strategies.add(:password) do
  def valid?
    params['email'].present? and params['password'].present?
  end

  def authenticate!
    user = User.where(email: params['email']).first
    if AuthService.perform(user, params['password'])
      success! user
    else
      fail! 'Oops'
    end
  end
end
