# frozen_string_literal: true

##
# app for creating new user
module RegistrationAppDoc
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
end
