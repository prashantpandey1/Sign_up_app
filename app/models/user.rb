class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true

  #return has digest of the string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST:
             BCrypt::Engine.cost
    BCrypt::Password.create(string, cost:cost)
  end

  #return a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #remember a user in the database  for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)

  end

  #return true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  #Activates an account
  def activate
    self.update_attribute(:activated, true)
    self.update_attribute(:activated_at, Time.zone.now)
  end

  #send activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  #set the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    self.update_attribute(:reset_digest, User.digest(reset_token))
    self.update_attribute(:reset_send_at, Time.zone.now)
  end

  #send password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  #Return true if a password reset has expired.
  def password_reset_expired?
    reset_send_at < 2.hours.ago
  end

  #Define a proto-feed
  # See "following users" for the full implementation
  def feed
    Micropost.where("user_id = ?", id)
  end

  # Follows a user
  def follow(other_user)
    # active_relationships.create(followed_id: other_user.id)
    following << other_user
  end

  # Unfollow a user
  def unfollow(other_user)
    # active_relationships.find_by(followed_id: other_user.id).destroy
    following.delete(other_user)
  end

  # Return true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  private

  #converts email to all lower-case
  def downcase_email
    self.email = email.downcase
  end

  #create and assigns the activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
