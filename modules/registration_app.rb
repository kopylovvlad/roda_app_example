# frozen_string_literal: true

##
# app for creating new user
module RegistrationApp
  def self.included(base)
    base.class_eval do
      route 'registration' do |r|

        # route: POST /registration
        r.post do
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
    return r.params.slice(
      'first_name', 'last_name', 'email', 'height', 'weight',
      'gender', 'city', 'birthdate', 'password', 'password_confirmation'
    )
  end
end
