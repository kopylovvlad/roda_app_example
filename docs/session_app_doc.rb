# frozen_string_literal: true

##
# app for session
module SessionAppDoc
  include Swagger::Blocks
  swagger_path '/sessions' do
    operation :get do
      key :tags, ['session']
    end
    operation :post do
      key :tags, ['session']
      parameter do
        key :name, :email
        key :in, :body
        key :description, 'Email'
        key :required, true
      end
      parameter do
        key :name, :password
        key :in, :body
        key :description, 'Password'
        key :required, true
      end
    end
    operation :delete do
      key :tags, ['session']
    end
  end
end
