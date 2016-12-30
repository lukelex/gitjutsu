module Github
  class Repository < ClosedStruct
    def create_hook(repo_id:)
      Hooks.new(api: api).create full_name, "localhost:3000/hooks/#{repo_id}"
    end

    def remove_hook(hook_id:)
      Hooks.new(api: api).remove full_name, hook_id
    end
  end
end
