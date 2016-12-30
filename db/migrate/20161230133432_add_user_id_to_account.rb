class AddUserIdToAccount < ActiveRecord::Migration[5.0]
  def change
    add_reference :accounts, :user, foreign_key: true, null: false
  end
end
