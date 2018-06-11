# frozen_string_literal: true

module Middleware
  def self.included(base)
    base.class_eval do
      use Rack::Session::Cookie, secret: ENV['SECRET'], key: 'roda_ex'
      use Warden::Manager do |manager|
        manager.scope_defaults :default, strategies: [:password]
        manager.failure_app = proc do
          [
            '401',
            { 'Content-Type' => 'application/json' },
            [{ success: false, error: 'Unauthorized' }.to_json]
          ]
        end
      end
    end
  end
end
