class CreateReceipts < ActiveRecord::Migration[7.0]
  def change
    create_table :receipts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :receipt_no
      t.decimal :total_summary
      t.integer :total_amount

      t.timestamps
    end
  end
end
