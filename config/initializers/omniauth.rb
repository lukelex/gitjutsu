require "omniauth"

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider \
    :github,
    ENV["GITHUB_CLIENT_ID"],
    ENV["GITHUB_CLIENT_SECRET"],
    provider_ignores_state: true,
    setup: Github::AuthOptions.method(:setup)
end
