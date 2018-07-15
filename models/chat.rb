# frozen_string_literal: true

class Chat
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: 'chats'

  scope :ordered, -> { reorder(updated_at: :desc) }

  # swagger
  include Swagger::Blocks
  swagger_schema :Chat do
    key :required, [:user1_id, :user2_id]
    property :id do
      key :type, :string
    end
    property :user1_id do
      key :type, :string
    end
    property :user2_id do
      key :type, :string
    end
  end

  field :user1_id, type: String
  field :user2_id, type: String

  validates :user1_id, :user2_id, presence: true
  validate :check_ids
  validate :check_users
  validate :is_exist?

  embeds_many :messages
  accepts_nested_attributes_for :messages, autosave: true

  def short_json
    {
      _id: id,
      user1_id: user1_id,
      user2_id: user2_id
    }
  end

  private

  def check_ids
    return if user1_id != user2_id
    errors.add(:user1_id, 'Must be uniq')
  end

  def check_users
    errors.add(:user1_id, 'User must exist') unless User.find(user1_id).present?
    errors.add(:user2_id, 'User must exist') unless User.find(user2_id).present?
  end

  def is_exist?
    chats = Chats::GetByUsersService.perform(user1_id, user2_id).count

    return if chats == 0
    errors.add(:user1_id, 'The same chat exists')
  end
end
