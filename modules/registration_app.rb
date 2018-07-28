# frozen_string_literal: true

##
# app for creating new user
module RegistrationApp
  include Swagger::Blocks
  swagger_path '/registration' do
    operation :post do
      key :tags, ['registration']
      %i[email first_name last_name].each do |sym|
        parameter do
          key :name, sym
          key :in, :body
          key :required, true
        end
      end
      %i[
        height weight city birthdate password password_confirmation
      ].each do |sym|
        parameter do
          key :name, sym
          key :in, :body
          key :required, false
        end
      end
      parameter do
        key :name, :gender
        key :in, :body
        key :description, "Shoul be 'male' or 'female'"
        key :required, false
      end
    end
  end

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
    r.params.slice(
      'first_name', 'last_name', 'email', 'height', 'weight',
      'gender', 'city', 'birthdate', 'password', 'password_confirmation'
    )
  end
end
