class Repository < ApplicationRecord
  belongs_to :account
  has_many :analyses

  validates :name, :github_id, :account, presence: true

  after_commit do
    active ? create_github_hook : remove_github_hook
  end

  def full_name
    "#{account.user.github_username}/#{name}"
  end

  delegate :pull_request, :compare, to: :source
  delegate :create_issue, to: :source

  private

  def create_github_hook
    return if hook_id

    source.create_hook(github_id: github_id).tap do |hook|
      update! hook_id: hook.id
    end
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
