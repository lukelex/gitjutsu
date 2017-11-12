require "omniauth"

class SessionsController < ApplicationController
  skip_before_action :authenticate

  def create
    create_session

    if github_token
      update_token
      update_scopes
    end

    # finished("auth_button")
    redirect_to repositories_path
  end

  def destroy
    session[:user_token] = nil

    redirect_to root_path
  end

  private

  def create_session
    session[:user_token] = user.remember_token
  end

  def user
    @user ||= find_user || create_user
  end

  def find_user
    User.find_by github_username: github_username
  end

  def create_user
    User.create! \
      github_username: github_username,
      email: github_email_address,
      github_token: github_token,
      github_token_scopes: Github::AuthOptions::SCOPES
  end

  def github_username
    auth_params.dig "info", "nickname"
  end

  def github_email_address
    auth_params.dig "info", "email"
  end

  def github_token
    auth_params.dig "credentials", "token"
  end

  def auth_params
    request.env["omniauth.auth"]
  end

  def update_token
    user.update! github_token: github_token
  end

  def update_scopes
    return unless scopes_changed?

    user.update! github_token_scopes: Github::AuthOptions::SCOPES
    user.repositories.clear
  end

  def scopes_changed?
    user.github_token_scopes != Github::AuthOptions::SCOPES
  end
end
