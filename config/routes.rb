require "resque/server"

Rails.application.routes.draw do
  case Rails.env
  when "development"
    default_url_options host: "localhost:3000"
  else
    default_url_options host: "mysterious-wave-31848.herokuapp.com"
  end

  mount Resque::Server.new, at: "/resque"

  root to: "application#home"

  get "/auth/github/callback", to: "sessions#create"
  get :sign_out, to: "sessions#destroy"

  resources :repositories, only: %i(index update)

  post "/analyses/:hook_id" => "analyses#create", as: "analyse"
end
