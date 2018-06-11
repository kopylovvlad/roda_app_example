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
  include BookmarkApp
  include ChatBaseApp

  route do |r|
    r.multi_route

    # route: GET /
    r.root do
      { succes: true, message: 'hello' }
    end
  end
end
