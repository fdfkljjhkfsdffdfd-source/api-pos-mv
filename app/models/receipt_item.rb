class ReceiptItem < ApplicationRecord
  belongs_to :receipt
  belongs_to :sku_master


  def self.by_receipt(receipt_id)
    where(receipt_id: receipt_id)
  end


  def as_json(options = {})
    super(options).merge(
      created_at: created_at.in_time_zone("Asia/Bangkok"),
      updated_at: updated_at.in_time_zone("Asia/Bangkok")
    )
  end

  

end
