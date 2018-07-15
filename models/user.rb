# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include BCrypt
  attr_accessor :password, :password_confirmation
  store_in collection: 'users'

  # swagger
  include Swagger::Blocks
  swagger_schema :User do
    key :required, [:email, :first_name, :last_name]
    property :id do
      key :type, :string
    end
    property :first_name do
      key :type, :string
    end
    property :last_name do
      key :type, :string
    end
    property :email do
      key :type, :string
    end
    property :height do
      key :type, :integer
    end
    property :weight do
      key :type, :integer
    end
    property :gender do
      key :type, :string
    end
    property :city do
      key :type, :string
    end
    property :birthdate do
      key :type, :date
    end
    property :active do
      key :type, :booleane
    end
  end

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :male, -> { where(gender: 'male') }
  scope :female, -> { where(gender: 'female') }

  field :first_name, type: String
  field :last_name,  type: String
  field :email,      type: String
  field :crypted_password, type: String
  field :height, type: Integer
  field :weight, type: Integer
  field :gender, type: String
  field :city, type: String
  field :birthdate, type: Date
  field :active, type: Boolean, default: false

  validates :password,
            length: { minimum: 3 },
            if: -> { new_record? || changes[:crypted_password] }
  validates :password,
            confirmation: true,
            if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation,
            presence: true,
            if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  before_save :save_password

  embeds_many :bookmarks
  accepts_nested_attributes_for :bookmarks, autosave: true

  def full_name
    [first_name, last_name].join(' ').strip
  end

  private

  def validate_gender
    self.gender = gender.downcase

    return if %w[male female].include?(gender)
    errors.add(:gender, "must be 'male' or 'female'")
  end

  def save_password
    return unless password.present? and password_confirmation
    self.crypted_password = Password.create(password)
    self.password = ''
    self.password_confirmation = ''
  end
end
