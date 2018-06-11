# frozen_string_literal: true

##
# app for session
module SessionApp
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
