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

  # TODO: test
  def self.get_chats(user1_id, user2_id)
    Chat.where(
      '$or' => [
        {user1_id: user1_id, user2_id: user2_id},
        {user1_id: user2_id, user2_id: user1_id},
      ]
    )
  end

  def self.get_all_for_user(user_id)
    Chat.where('$or' => [{user1_id: user_id}, {user2_id: user_id}])
  end

  def check_ids
    return if user1_id != user2_id
    errors.add(:user1_id, 'Must be uniq')
  end

  def is_exist?
    chats = Chat.get_chats(user1_id, user2_id).count

    return if chats == 0
    errors.add(:user1_id, 'The same chat exists')
  end
end
