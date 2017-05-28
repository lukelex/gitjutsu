module Github
  class AuthOptions
    SCOPES = "repo,user:email".freeze

    class << self
      def setup(env)
        options = new(env)
        env["omniauth.strategy"].options.merge! options.to_hash
      end
    end

    def initialize(env)
      @request = Rack::Request.new(env)
    end

    def to_hash
      if @request.params["access"] == "full"
        { scope: SCOPES }
      else
        { scope: "public_repo,user:email" }
      end

      # TODO: figure out why "access" is nil
      { scope: SCOPES }
    end
  end
end
