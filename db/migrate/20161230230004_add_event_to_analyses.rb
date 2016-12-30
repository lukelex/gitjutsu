class AddEventToAnalyses < ActiveRecord::Migration[5.0]
  def change
    add_column :analyses, :event, :string
  end
end
