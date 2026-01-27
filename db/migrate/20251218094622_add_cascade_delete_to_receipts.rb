class AddCascadeDeleteToReceipts < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :receipts, :users
    add_foreign_key :receipts, :users, on_delete: :cascade

    remove_foreign_key :receipt_items, :receipts
    add_foreign_key :receipt_items, :receipts, on_delete: :cascade
  end
end
