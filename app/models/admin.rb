class Admin < ActiveRecord::Base

  mount_uploader :avatar, AvatarUploader

  has_secure_password

  attr_accessor :remember_token

  validates_presence_of :name, :nickname
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, allow_blank: true
  validates_uniqueness_of :name, :email, case_sensitive: false

  before_save :downcase_email

  def remember
    self.remember_token = Admin.generate_token
    update_attribute :remember_digest, Admin.digest(remember_token)
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  class << self

    def generate_token
      SecureRandom.urlsafe_base64
    end

    def digest(str)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(str, cost: cost)
    end

  end

  private

    def downcase_email
      self.email.downcase! if email
    end


end
