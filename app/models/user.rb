class User < ApplicationRecord
  has_one :account
  has_many :repositories, through: :account

  validates :github_username, :email, presence: true

  before_create :generate_remember_token
  after_create :create_account

  def to_s
    github_username
  end

  private

  def github_user
    Github::User.new self
  end

  def generate_remember_token
    self.remember_token = SecureRandom.hex(20)
  end

  def create_account
    Account.create user: self
  end
end
