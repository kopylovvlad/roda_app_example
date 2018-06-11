# frozen_string_literal: true

module ProfileApp
  include PaginationHandler

  def self.included(base)
    base.class_eval do
      route 'profiles' do |r|
        env['warden'].authenticate!

        r.is do

          # search profiles
          # route: GET /profiles
          r.get do
            @users = Users::SearchService.perform(search_params(r))
            @users = paginate_yeild(r, @users)
            {
              success: true,
              users: @users,
              pagination: pagination_json(@users)
            }
          end
        end

        r.on :id do |profile_id|
          @user = User.find(profile_id)
          r.halt(404) unless @user.present?

          # show profile
          # route: GET /profiles/:id
          r.get do
            { success: true, user: @user }
          end

          # update own profile
          # route: PATCH /profiles/:id
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

  def search_params(r)
    r.params.slice(
      'first_name', 'last_name', 'email', 'city', 'height_after',
      'height_before', 'weight_after', 'weight_before', 'gender',
      'birthdate_before', 'birthdate_after'
    )
  end

  def user_params(r)
    r.params.slice(
      'first_name', 'last_name', 'email', 'height', 'weight',
      'gender', 'city', 'birthdate', 'password', 'password_confirmation'
    )
  end
end
