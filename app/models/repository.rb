class Repository < ApplicationRecord
  belongs_to :account
  has_many :analyses

  validates :name, :github_id, :account, presence: true

  after_create_commit :create_github_hook
  after_update_commit :toggle_github_hook
  after_destroy_commit :remove_github_hook

  def full_name
    "#{account.user.github_username}/#{name}"
  end

  delegate :pull_request, :compare, to: :source
  delegate :issues, :create_issue, to: :source

  private

  def create_github_hook
    return if hook_id

    source
      .create_hook(github_id: github_id)
      .tap { |hook| update! hook_id: hook.id }
  end

  def toggle_github_hook
    source.toggle_hook \
      github_id: github_id,
      hook_id: hook_id,
      active: active
  end

  def remove_github_hook
    return unless hook_id

    if source.remove_hook(hook_id: hook_id)
      update! hook_id: nil
    end
  end

  def source
    Github::Repository.new \
      name: name,
      api: account.user.github_api
  end
end
