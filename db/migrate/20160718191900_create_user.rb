class CreateUser < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :github_username, null: false
      t.string :github_token, null: false
      t.string :github_token_scopes, null: false
    end
  end
end
