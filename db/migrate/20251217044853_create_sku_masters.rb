class CreateSkuMasters < ActiveRecord::Migration[7.0]
  def change
    create_table :sku_masters do |t|
      t.string :name
      t.references :category, null: false, foreign_key: true
      t.integer :amount
      t.decimal :price

      t.timestamps
    end
  end
end
