# frozen_string_literal: true

class Chat
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: 'chats'

  scope :ordered, ->{ reorder(updated_at: :desc) }

  field :user1_id, type: String
  field :user2_id, type: String

  validates :user1_id, :user2_id, presence: true
  validate :check_ids
  validate :check_users
  validate :is_exist?

  embeds_many :messages
  accepts_nested_attributes_for :messages , :autosave => true

  private

  def check_ids
    return if user1_id != user2_id
    errors.add(:user1_id, 'Must be uniq')
  end

  # TODO: test
  def check_users
    unless User.find(user1_id).present?
      errors.add(:user1_id, 'User must exist')
    end
    unless User.find(user2_id).present?
      errors.add(:user2_id, 'User must exist')
    end
  end

  def is_exist?
    chats = Chats::GetByUsersService.perform(user1_id, user2_id).count

    return if chats == 0
    errors.add(:user1_id, 'The same chat exists')
  end
end
