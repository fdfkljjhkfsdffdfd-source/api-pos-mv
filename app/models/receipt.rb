class Receipt < ApplicationRecord
  belongs_to :user
  has_many :receipt_items, dependent: :destroy

    def self.generate_receipt_no
    today = Time.zone.today
    date_str = today.strftime("%Y%m%d")

    count_today = where(
      created_at: today.beginning_of_day..today.end_of_day
    ).count + 1

    format("R%s-%04d", date_str, count_today)
  end





  def as_json_with_items
    {
      id: id,
      receipt_no: receipt_no,
      total_summary: total_summary,
      total_amount: total_amount,
      created_at: created_at,
      items: receipt_items.includes(:sku_master).map do |ri|
        {
          id: ri.id,
          sku_master_id: ri.sku_master_id,
          sku_name: ri.sku_master.name,
          quantity: ri.quantity,
          price: ri.price
        }
      end
    }
  end




  def self.generate_receipt_no
    today = Time.zone.today
    date_str = today.strftime("%Y%m%d")

    count_today = where(
      created_at: today.beginning_of_day..today.end_of_day
    ).count + 1

    format("R%s-%04d", date_str, count_today)
  end










def self.pdf(receipts)
  return if receipts.blank?

  first_receipt = receipts.first

  Prawn::Document.new(page_size: "A4", margin: 50) do |pdf|
    # Header
    pdf.text "Receipt", size: 24, style: :bold, align: :center
    pdf.move_down 20

    # Receipt info
    pdf.text "Receipt No: #{first_receipt.receipt_no}", size: 12
    pdf.text "Date: #{first_receipt.created_at.strftime("%d/%m/%Y")}", size: 12
    pdf.text "Customer ID: #{first_receipt.user_id}", size: 12
    pdf.move_down 20

    # Table header
    data = [["Item", "Quantity", "Price", "Total"]]

    # Loop รายการ receipt_items ของ receipt
    first_receipt.receipt_items.includes(:sku_master).each do |item|
      data << [
        item.sku_master.name,
        item.quantity,
        item.price.to_f,
        (item.quantity * item.price.to_f)
      ]
    end

    # สร้าง table
    pdf.table(data, header: true, width: pdf.bounds.width) do
      row(0).font_style = :bold
      row(0).background_color = "cccccc"
      columns(1..3).align = :center
    end

    pdf.move_down 20
    # สรุปยอดรวม
    total_amount = first_receipt.total_summary || first_receipt.receipt_items.sum { |i| i.quantity * i.price.to_f }
    pdf.text "Total Amount: #{total_amount}", size: 16, style: :bold, align: :right
    pdf.move_down 40
    pdf.text "Thank you for your business", size: 12, align: :center
  end
end



















  def as_json(options = {})
    super(
      only: [:id, :receipt_no, :total_summary, :total_amount],
      methods: [:created_at_thai]
    )
  end

  def created_at_thai
    created_at.in_time_zone("Bangkok").iso8601
  end















  









end
