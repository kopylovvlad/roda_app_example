# frozen_string_literal: true

##
# app for creating new user
module RegistrationApp
  def self.included(base)
    base.class_eval do
      route 'registration' do |r|
        r.post do
          # creating new user
          user = User.new(reg_params(r))
          if user.valid? and user.save
            response.status = 201
            { success: true, user: user }
          else
            response.status = 400
            { success: false, errors: user.errors }
          end
        end
      end
    end
  end

  private

  def reg_params(r)
    {
      first_name: r.params['first_name'],
      last_name: r.params['last_name'],
      email: r.params['email'],
      height: r.params['height'],
      weight: r.params['weight'],
      gender: r.params['gender'],
      city: r.params['city'],
      birthdate: r.params['birthdate'],
      password: r.params['password'],
      password_confirmation: r.params['password_confirmation']
    }
  end
end
