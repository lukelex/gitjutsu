class AddGithubIdToRepositories < ActiveRecord::Migration[5.1]
  def change
    add_column :repositories, :github_id, :bigint, null: false
  end
end
