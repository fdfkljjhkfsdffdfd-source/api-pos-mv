class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  def recalculate_totals!
    self.total_amount  = cart_items.sum(:quantity)
    self.total_summary = cart_items.sum(:price)
    save!
  end


   def clear!
    cart_items.destroy_all
    update!(
      total_summary: 0,
      total_amount: 0,
      status: "active"
    )
  end

  




  
end
