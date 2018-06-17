# frozen_string_literal: true

module Users
  module SearchService
    PARAMS_MAP = {
      'id' => ->(value) { { id: value } },
      'first_name' => ->(value) { { 'first_name' => value } },
      'last_name' => ->(value) { { 'last_name' => value } },
      'email' => ->(value) { { 'email' => value } },
      'city' => ->(value) { { 'city' => value } },
      'height_after' => ->(value) { { height: { :$gt => value } } },
      'height_before' => ->(value) { { height: { :$lt => value } } },
      'weight_after' => ->(value) { { weight: { '$gt' => value } } },
      'weight_before' => ->(value) { { weight: { '$lt' => value } } },
      'gender' => ->(value) { { gender: value } },
      'birthdate_before' => ->(value) { { birthdate: { :$lte => Date.parse(value) } } },
      'birthdate_after' => ->(value) { { birthdate: { :$gte => Date.parse(value) } } }
    }.freeze

    def self.perform(params = {})
      where_params = {}

      PARAMS_MAP.keys.each do |item|
        next unless params[item].present?
        where_params.merge!(PARAMS_MAP[item][params[item]])
      end

      ::User.active.where(where_params)
    end
  end
end
