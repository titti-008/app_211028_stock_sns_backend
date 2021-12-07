class CreateStockRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :stock_relationships do |t|
      t.integer :stock_id
      t.integer :user_id

      t.timestamps
    end
    add_index :stock_relationships, [:stock_id, :user_id], unique: true
  end
end
