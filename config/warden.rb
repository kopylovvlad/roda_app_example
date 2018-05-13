# frozen_string_literal: true

require 'warden'

Warden::Manager.serialize_into_session(&:id)
Warden::Manager.serialize_from_session { |id| User.find(id) }

Warden::Strategies.add(:password) do
  def valid?
    params['email'] || params['password']
  end

  def authenticate!
    user = User.where(email: params['email']).first
    if user&.authenticate(params['password'])
      success! user
    else
      fail! 'Oops'
    end
  end
end
