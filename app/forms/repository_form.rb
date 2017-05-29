class RepositoryForm
  include ActiveModel::Model

  def initialize(repo, internal_repo)
    @repo = repo
    @internal_repo = internal_repo
  end

  def to_param
    @repo.id
  end

  def persisted?
    true
  end

  delegate :active, to: :@internal_repo, allow_nil: true
  delegate :permissions, :private?, to: :@repo
  delegate :html_url, :full_name, to: :@repo
  delegate :description, to: :@repo
end
