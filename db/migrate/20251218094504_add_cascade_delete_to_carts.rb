class AddCascadeDeleteToCarts < ActiveRecord::Migration[6.0]
  def change
    # carts.user_id
    remove_foreign_key :carts, :users
    add_foreign_key :carts, :users, on_delete: :cascade

    # cart_items.cart_id
    remove_foreign_key :cart_items, :carts
    add_foreign_key :cart_items, :carts, on_delete: :cascade

    # receipts.user_id
    remove_foreign_key :receipts, :users
    add_foreign_key :receipts, :users, on_delete: :cascade

    # receipt_items.receipt_id
    remove_foreign_key :receipt_items, :receipts
    add_foreign_key :receipt_items, :receipts, on_delete: :cascade
  end
end
