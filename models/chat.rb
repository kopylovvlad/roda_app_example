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
  validate :is_exist?

  embeds_many :messages
  accepts_nested_attributes_for :messages , :autosave => true

  private

  def check_ids
    return if user1_id != user2_id
    errors.add(:user1_id, 'Must be uniq')
  end

  def is_exist?
    chats = Chats::GetByUsersService.perform(user1_id, user2_id).count

    return if chats == 0
    errors.add(:user1_id, 'The same chat exists')
  end
end
