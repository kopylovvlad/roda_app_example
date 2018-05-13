# frozen_string_literal: true

# router is here
class App < Roda
  # plugins
  plugin :head
  plugin :json
  plugin :all_verbs
  plugin :environments
  plugin :middleware

  # middlewares
  use Rack::Session::Cookie, secret: ENV['SECRET'], key: 'roda_ex'
  use Warden::Manager do |manager|
    manager.scope_defaults :default, strategies: [:password]
    manager.failure_app = proc do
      [
        '401',
        { 'Content-Type' => 'application/json' },
        [{ error: 'Unauthorized' }.to_json]
      ]
    end
  end

  route do |r|
    r.root do
      { succes: true, message: 'hello' }
    end

    r.on 'sessions' do
      r.is do
        r.get do
          { user: env['warden'].user }
        end

        r.post do
          env['warden'].authenticate!

          { success: true, message: 'ok', user: env['warden'].user }
        end

        r.delete do
          env['warden'].logout

          { success: true, message: 'ok' }
        end
      end
    end
    # add 404
    # add 500
  end
end
