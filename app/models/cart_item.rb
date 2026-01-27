class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :sku_master

  validates :quantity, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  def self.add_item!(user:, sku_master_id:, quantity:)
    ActiveRecord::Base.transaction do
      cart = Cart.find_or_create_by!(
        user_id: user.id
      )

      sku = SkuMaster.find(sku_master_id)
      raise "SKU price missing" if sku.price.nil?

      cart_item = cart.cart_items.lock.find_or_initialize_by(
        sku_master_id: sku.id
      )

      cart_item.quantity ||= 0
      cart_item.quantity += quantity.to_i
      cart_item.price = sku.price * cart_item.quantity
      cart_item.save!
      
      cart.recalculate_totals!
      
      cart_item
    end
  end










end
