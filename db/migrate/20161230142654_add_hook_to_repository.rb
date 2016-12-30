class AddHookToRepository < ActiveRecord::Migration[5.0]
  def change
    add_column :repositories, :hook_id, :integer
  end
end
