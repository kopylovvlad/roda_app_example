# frozen_string_literal: true

class Bookmark
  include Mongoid::Document
  include Mongoid::Timestamps

  # swagger
  include Swagger::Blocks
  swagger_schema :Bookmark do
    key :required, [:user_id, :user_name]
    property :id do
      key :type, :string
    end
    property :user_id do
      key :type, :string
    end
    property :user_name do
      key :type, :string
    end
  end

  field :user_id, type: String
  field :user_name, type: String

  embedded_in :user

  validates :user_id, presence: true
  validates :user_name, presence: true
  validates :user_id, uniqueness: { scope: :user }
end
