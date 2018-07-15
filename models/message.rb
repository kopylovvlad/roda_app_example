# frozen_string_literal: true

class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  scope :ordered, -> { reorder(created_at: :desc) }
  scope :by_user, ->(user_id) { where(to_user_id: user_id) }
  scope :unviewed, -> { where(viewed: false) }

  # swagger
  include Swagger::Blocks
  swagger_schema :Message do
    key :required, [:to_user_id, :text]
    property :id do
      key :type, :string
    end
    property :to_user_id do
      key :type, :string
    end
    property :text do
      key :type, :string
    end
    property :viewed do
      key :type, :boolean
    end
  end

  field :to_user_id, type: String
  field :text, type: String
  field :viewed, type: Boolean, default: false

  embedded_in :chat

  validates :to_user_id, :text, presence: true
end
