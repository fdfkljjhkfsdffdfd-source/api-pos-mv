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

  


  def self.datatable(params)
    begin
      scope = includes(:sku_master)

      # ----------------
      # SEARCH
      # ----------------
      if params.dig(:search, :value).present?
        keyword = params[:search][:value].to_s.strip
        scope = scope.where("note ILIKE ?", "%#{keyword}%")
      end

      total = Cart.count
      filtered = scope.count

      # ----------------
      # ORDER SAFE
      # ----------------
      allowed_columns = %w[id quantity created_at]

      if params[:order].present? && params[:columns].present?
        column_index = params[:order]["0"][:column].to_i rescue 0
        dir = params[:order]["0"][:dir] == "desc" ? "desc" : "asc"

        column_name = params[:columns][column_index][:data] rescue "id"
        column_name = "id" unless allowed_columns.include?(column_name)

        scope = scope.order("#{column_name} #{dir}")
      else
        scope = scope.order(id: :asc)
      end

      # ----------------
      # PAGINATION SAFE
      # ----------------
      start  = params[:start].to_i
      length = params[:length].to_i

      start = 0 if start.negative?
      length = 10 if length <= 0
      length = 100 if length > 100

      records = scope.offset(start).limit(length)

      # ----------------
      # CALC PAGE
      # ----------------
      page = (start / length) + 1
      per_page = length

      {
        carts: records.as_json(
          include: {
            sku_master: {
              only: [:id, :name]
            }
          }
        ),
        pagination: {
          page: page,
          per_page: per_page,
          total: filtered,
          total_pages: (filtered / per_page.to_f).ceil
        }
      }

    rescue => e
      Rails.logger.error "CART DATATABLE ERROR: #{e.message}"

      {
        carts: [],
        pagination: {
          page: 1,
          per_page: 10,
          total: 0,
          total_pages: 0
        },
        error: "invalid_params"
      }
    end
  end




  



  
end
