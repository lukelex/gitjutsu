class CreateAnalyses < ActiveRecord::Migration[5.0]
  def change
    create_table :analyses do |t|
      t.belongs_to :repository
      t.jsonb :payload, null: false
      t.datetime :created_at, null: false
      t.datetime :finished_at
    end

    add_index :analyses, :payload, using: :gin
  end
end
