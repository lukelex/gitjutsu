class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate, except: :home

  def home
    redirect_to(repositories_path) if signed_in?

    render "home/index"
  end

  private

  def authenticate
    redirect_to(root_path) unless signed_in?
  end

  def signed_in?
    !!current_user&.github_token.present?
  end

  def current_user
    @_current_user ||= User.find_by(remember_token: session[:user_token])
  end
end
