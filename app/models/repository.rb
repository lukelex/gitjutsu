class Repository < ApplicationRecord
  belongs_to :account

  validates :name, :account, presence: true
end
