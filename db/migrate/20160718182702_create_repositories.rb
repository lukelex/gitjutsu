class CreateRepositories < ActiveRecord::Migration[5.0]
  def change
    create_table :repositories do |t|
      t.string :name

      t.timestamps
    end

    add_reference :repositories, :account, foreign_key: true
  end
end
