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

  route do |r|
    r.multi_route
    r.root do
      { succes: true, message: 'hello' }
    end

    r.is 'profiles', Hash do |search_hash|
      # TODO:
      # find profiles
    end

    r.is 'profiles', Integer do |profile_id|
      # @artist = Artist[artist_id]
      # check_access(@artist)
      # r.halt(404) unless @artist

      r.get do
        # TODO:
        # show profile
      end

      r.patch do
        # TODO:
        # update own profile
      end
    end
  end
end
