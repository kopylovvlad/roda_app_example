# frozen_string_literal: true

# router is here
class App < Roda
  # plugins
  include Plugins

  # middlewares
  include Middleware

  # apps
  include RegistrationApp
  include SessionApp
  include ProfileApp

  route do |r|
    r.multi_route
    r.root do
      { succes: true, message: 'hello' }
    end
  end
end
