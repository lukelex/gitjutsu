class Account < ApplicationRecord
  has_one :user
  has_many :repositories

  validate :user, presence: true
end
