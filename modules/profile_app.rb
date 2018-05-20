# frozen_string_literal: true

module ProfileApp
  def self.included(base)
    base.class_eval do
      route 'profiles' do |r|
        # env['warden'].authenticate!

        # TODO:
        # find profiles
        r.is do
          r.get do
            # TODO:
            # show profile
            # add pagination
            { success: true, users: User.search }
          end
        end

        r.on :id do |profile_id|
          @user = User.find(profile_id)
          r.halt(404) unless @user.present?

          r.get do
            { success: true, user: @user }
          end

          r.patch do
            unless env['warden'].user.id == @user.id
              r.halt(405, {'Content-Type'=>'application/json'}, {}.to_json)
            end

            if @user.update_attributes(user_params(r))
              { success: true, user: @user }
            else
              { success: false, errors: @user.errors }
            end
          end
        end
      end
    end
  end

  private

  def user_params(r)
    return r.params.slice(
      'first_name', 'last_name', 'email', 'height', 'weight',
      'gender', 'city', 'birthdate', 'password', 'password_confirmation'
    )
  end
end
