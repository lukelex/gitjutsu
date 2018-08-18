# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate, except: :home

  def home
    return redirect_to(repositories_path) if signed_in?

    render "home/index"
  end

  helper_method def signed_in?
    !!current_user.github_token.present?
  end

  private

  def authenticate
    redirect_to(root_path) unless signed_in?
  end

  def current_user
    @_current_user ||=
      User.find_by(remember_token: session[:user_token]) ||
      UnknownUser.new
  end

  class UnknownUser
    def github_token; end
  end
end
