# frozen_string_literal: true

module UsersSearchService
  def self.perform(params = {})
    scope = ::User.active

    if params['id'].present?
      scope = scope.find(params['id']).to_a
    end

    ['first_name', 'last_name', 'email', 'city'].each do |item|
      next unless params[item].present?
      scope = scope.where(item => params[item])
    end

    if params['height_after'].present?
      scope = scope.where(height: { :$gt => params['height_after']})
    end

    if params['height_before'].present?
      scope = scope.where(height: { :$lt => params['height_before'] })
    end

    if params['weight_after'].present?
      scope = scope.where(weight: { '$gt' => params['weight_after']})
    end

    if params['weight_before'].present?
      scope = scope.where(weight: { '$lt' => params['weight_before']})
    end

    if params['gender'].present? and %w[male female].include?(params['gender'])
      scope = scope.where(gender: params['gender'])
    end

    if params['birthdate_before'].present?
      scope = scope.where(
        birthdate: { :$lte => Date.parse(params['birthdate_before']) }
      )
    end

    if params['birthdate_after'].present?
      scope = scope.where(
        birthdate: { :$gte => Date.parse(params['birthdate_after']) }
      )
    end

    scope
  end
end
