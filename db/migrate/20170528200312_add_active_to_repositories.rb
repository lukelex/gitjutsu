class AddActiveToRepositories < ActiveRecord::Migration[5.1]
  def change
    add_column :repositories, :active, :boolean, null: false, default: true
  end
end
