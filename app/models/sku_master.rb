class SkuMaster < ApplicationRecord
  belongs_to :category

  validates :name, presence: true, uniqueness: true


  
  def as_json(options = {})
    super(options).merge(
      price: price.to_f
    )
  end












  def self.by_category(category_id)
    if category_id.present?
      where(category_id: category_id)
    else
      all
    end
  end









  def self.sku_master_all
    {
      sku_masters: SkuMaster
        .joins(:category)
        .select(
          'sku_masters.id,
          sku_masters.name,
          sku_masters.amount,
          sku_masters.price,
          sku_masters.created_at,
          sku_masters.updated_at,
          sku_masters.category_id,
          categories.name AS category_name'
        )
        .order('sku_masters.id'),
    }
  end


  # GET /sku_masters/search?q=keyword
  def self.search(keyword)
    if keyword.present?
      where("name ILIKE ?", "%#{keyword}%")
    else
      all
    end
  end




  


  # ===== helper =====
  def category_name
    category&.name
  end

  def price_float
    price.to_f
  end

  # ===== pagination + filter =====
 def self.paginate_with_category(params)
  page     = params[:page].presence || 1
  per_page = params[:per_page].presence || 10

  # scope = includes(:category).order(:id)
    scope = includes(:category)

  # filter by category
  if params[:category_id].present?
    scope = scope.where(category_id: params[:category_id])
  end

  # search by name
  if params[:search].present?
    scope = scope.search(params[:search])
  end


  if params[:sort].present?
    scope = scope.order(id: :desc)
  end

  



  total = scope.count

  records = scope
    .offset((page.to_i - 1) * per_page.to_i)
    .limit(per_page)

  {
    sku_masters: records.as_json(
      methods: [:category_name, :price_float],
      except: [:price]
    ),
    pagination: {
      page: page.to_i,
      per_page: per_page.to_i,
      total: total,
      total_pages: (total / per_page.to_f).ceil
    }
  }
end










end
