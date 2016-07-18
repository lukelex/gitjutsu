class Account < ActiveRecord::Base
  has_one :user
  has_many :repositories

  validate :user, presence: true
end
