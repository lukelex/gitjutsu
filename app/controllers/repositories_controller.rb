# frozen_string_literal: true

class RepositoriesController < ApplicationController
  rescue_from Octokit::NotFound do |exc|
    redirect_to root_path, error: exc.message
  end

  def index
    user_repos   = current_user.repositories
    github_repos = current_user.github_api.repos
      .sort_by { |repo| repo.permissions.admin.to_s }.reverse

    @repos = parse_all(github_repos, user_repos)
  end

  def update
    repository = current_user.account.repositories
      .find_or_initialize_by(github_id: params[:id])

    if repository.update(update_params)
      flash[:success] = t(".#{repository.active ? 'activated' : 'deactivated'}")
    else
      flash[:error] = t(".failed")
    end

    redirect_to repositories_path
  end

  private

  def update_params
    @_update_params ||= params
      .require(:repository)
      .permit(:name, :active)
  end

  def parse_all(github_repos, user_repos)
    github_repos.map do |github_repo|
      user_repo = user_repos
        .find { |ur| ur.github_id == github_repo.id }

      RepositoryForm.new(github_repo, user_repo)
    end
  end
end
