# frozen_string_literal: true

class Bookmark
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: String
  field :user_name, type: String

  embedded_in :user

  validates :user_id, presence: true
  validates :user_name, presence: true
  validates :user_id, uniqueness: { scope: :user }
end
