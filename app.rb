# frozen_string_literal: true

# router is here
class App < Roda
  # plugins
  # https://github.com/jeremyevans/roda/tree/master/lib/roda/plugins
  plugin :head
  plugin :json
  plugin :all_verbs
  plugin :environments
  plugin :middleware
  plugin :run_handler
  plugin :error_handler do |e|
    puts 'error_handler:'
    puts e.inspect
    puts e.backtrace
    { success: false, message: 'internal server error' }
  end
  plugin :not_found do |e|
    unless ENV['RACK_ENV'] == 'test'
      puts 'not_found:'
      puts e.inspect
    end
    {}
  end

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

    r.is 'registration' do
      r.post do
        # creating new user
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

    r.is 'profiles', Hash do |search_hash|
      # TODO:
      # find profiles
    end

    r.is 'profiles', Integer do |profile_id|
      # @artist = Artist[artist_id]
      # check_access(@artist)

      r.get do
        # TODO:
        # show profile
      end

      r.patch do
        # TODO:
        # update own profile
      end
    end

    r.on 'sessions' do
      r.is do
        r.get do
          { user: env['warden'].user }
        end

        r.post do
          env['warden'].authenticate!
          response.status = 201
          { success: true, message: 'ok', user: env['warden'].user }
        end

        r.delete do
          env['warden'].logout

          { success: true, message: 'ok' }
        end
      end
    end
  end

  private

  def reg_params(r)
    {
      first_name: r.params['first_name'],
      last_name: r.params['last_name'],
      email: r.params['email'],
      height: r.params['height'],
      weight: r.params['weight'],
      gender: r.params['gender'],
      city: r.params['city'],
      birthdate: r.params['birthdate'],
      password: r.params['password'],
      password_confirmation: r.params['password_confirmation']
    }
  end
end
