class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_summary
      t.integer :total_amount
      t.string :status

      t.timestamps
    end
  end
end
