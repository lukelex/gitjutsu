require "resque/server"

Rails.application.routes.draw do
  case Rails.env
  when "development"
    default_url_options host: "localhost:3000"
  else
    default_url_options host: "codetags.herokuapp.com", protocol: "https"
  end

  mount Resque::Server.new, at: "/resque"

  root to: "application#home"

  get "/auth/github/callback", to: "sessions#create"
  get :sign_out, to: "sessions#destroy"

  resources :repositories, only: %i(index update)

  post "/analyses/:github_id" => "analyses#create", as: "analyse"
end
