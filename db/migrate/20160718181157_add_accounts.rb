class AddAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.timestamps
    end
  end
end
