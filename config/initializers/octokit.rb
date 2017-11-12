# frozen_string_literal: true

if ENV["DEBUG_OCTOKIT"]
  require "octokit"
  require "faraday"

  # TODO: Find a way to log only the the request string
  stack = Faraday::RackBuilder.new do |builder|
    builder.response :logger
    builder.use Octokit::Response::RaiseError
    builder.adapter Faraday.default_adapter
  end
  Octokit.middleware = stack
end
