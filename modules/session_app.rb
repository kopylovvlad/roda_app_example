# frozen_string_literal: true

##
# app for session
module SessionApp
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

  def self.included(base)
    base.class_eval do
      route 'sessions' do |r|
        r.is do
          # route: GET /sessions
          r.get do
            { user: env['warden'].user }
          end

          # route: POST /sessions
          r.post do
            env['warden'].authenticate!
            response.status = 201
            { success: true, message: 'ok', user: env['warden'].user }
          end

          # route: DELETE /sessions
          r.delete do
            env['warden'].logout

            { success: true, message: 'ok' }
          end
        end
      end
    end
  end
end
