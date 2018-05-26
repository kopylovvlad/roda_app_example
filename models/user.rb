# frozen_string_literal: true

##
# model users
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include BCrypt
  attr_accessor :password, :password_confirmation
  store_in collection: 'users'

  scope :active, ->{ where(active: true) }
  scope :inactive, ->{ where(active: false) }
  scope :male, ->{ where(gender: 'male') }
  scope :female, ->{ where(gender: 'female') }

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

  def self.search(params = {})
    scope = active

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

  # rewrite it!!!
  def authenticate(example_password)
    if BCrypt::Password.new(crypted_password) == example_password
      self
    else
      nil
    end
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
