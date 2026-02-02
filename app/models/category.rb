class Category < ApplicationRecord
    has_many :sku_masters
    validates :name, presence: true, uniqueness: true




    def self.datatable(params)
        begin
          scope = Category.all
    
          # ----------------
          # SEARCH
          # ----------------
          if params.dig(:search, :value).present?
            keyword = params[:search][:value].to_s.strip
            scope = scope.where("name ILIKE ?", "%#{keyword}%")
          end
    
          total = Category.count
          filtered = scope.count
    
          # ----------------
          # ORDER SAFE
          # ----------------
          allowed_columns = %w[id name created_at]
    
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
            categories: records.as_json,
            pagination: {
              page: page,
              per_page: per_page,
              total: filtered,
              total_pages: (filtered / per_page.to_f).ceil
            }
          }
    
        rescue => e
          Rails.logger.error "CATEGORY DATATABLE ERROR: #{e.message}"
    
          {
            categories: [],
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
