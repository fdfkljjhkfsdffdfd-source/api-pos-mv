class CreateReceiptItems < ActiveRecord::Migration[7.0]
  def change
    create_table :receipt_items do |t|
      t.references :receipt, null: false, foreign_key: true
      t.references :sku_master, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
