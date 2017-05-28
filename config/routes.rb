require "resque/server"

Rails.application.routes.draw do
  default_url_options host: "gitdoer.io"

  mount Resque::Server.new, at: "/resque"

  root to: "application#home"

  get "/auth/github/callback", to: "sessions#create"

  resources :repositories

  post "/analyses/:hook_id" => "analyses#create", as: "analyse"
end
