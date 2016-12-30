class Repository < ApplicationRecord
  belongs_to :account

  validates :name, :account, presence: true

  after_create :create_hook
  after_destroy :remove_hook

  def full_name
    "#{account.user.github_username}/#{name}"
  end

  private

  def create_hook
    source.create_hook(repo_id: id).tap do |hook|
      update! hook_id: hook.id
    end
  end

  def remove_hook
    if source.remove_hook(hook_id: hook_id)
      update! hook_id: nil
    end
  end

  def source
    Github::Repository.new \
      full_name: full_name,
      api: account.user.github_api
  end
end
