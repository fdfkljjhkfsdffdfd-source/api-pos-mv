# app/models/payment.rb
class Payment
  def self.cash!(user:)
    ActiveRecord::Base.transaction do
      cart = Cart.find_by!(user_id: user.id, status: "active")
      raise "Cart is empty" if cart.cart_items.empty?

      receipt = Receipt.create!(
        user_id: user.id,
        receipt_no: Receipt.generate_receipt_no
      )

      total_summary = 0
      total_amount  = 0
      items_data    = []

      cart.cart_items.each do |item|
        unit_price  = item.sku_master.price
        total_price = unit_price * item.quantity

        ReceiptItem.create!(
          receipt: receipt,
          sku_master: item.sku_master,
          quantity: item.quantity,
          price: unit_price
        )

        total_summary += total_price
        total_amount  += item.quantity

        items_data << {
          sku_master_id: item.sku_master_id,
          sku_name: item.sku_master.name,
          quantity: item.quantity,
          unit_price: unit_price,
          total_price: total_price
        }
      end

      receipt.update!(
        total_summary: total_summary,
        total_amount: total_amount
      )

      cart.cart_items.destroy_all
      cart.update!(
        total_summary: 0,
        total_amount: 0
      )


      {
        id: receipt.id,
        receipt_no: receipt.receipt_no,
        total_summary: receipt.total_summary,
        total_amount: receipt.total_amount,
        created_at: receipt.created_at.in_time_zone("Bangkok").iso8601,
        items: items_data
      }
    end
  end
end
