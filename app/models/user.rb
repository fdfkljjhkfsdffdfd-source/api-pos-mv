class User < ApplicationRecord
  has_secure_password
  has_one :cart, dependent: :destroy
  has_many :receipts, dependent: :destroy
  after_create :create_cart_for_user
  validates :role,
            inclusion: { in: %w[admin user], message: "%{value} is not a valid role" }

  validates :username,
            presence: true,
            uniqueness: true

  validates :password,
            presence: true,
            length: { minimum: 6 },
            on: :create




  # =========================
  # SERIALIZER
  # =========================
  def self.respond_to_json(users)
    users.map do |user|
      {
        id: user.id,
        username: user.username,
        name: user.name,
        role: user.role
      }
    end
  end






  # =========================
  # QUERY (ActiveRecord ONLY)
  # =========================

  # ใช้แทน all_sql (ปลอดภัย + เร็ว)
  def self.list_basic
    select(:id, :username, :name, :role)
  end

  def self.search(keyword)
    return list_basic if keyword.blank?

    safe = sanitize_sql_like(keyword)

    where(
      "username ILIKE :q OR name ILIKE :q",
      q: "%#{safe}%"
    ).select(:id, :username, :name, :role)
  end

  # =========================
  # OPTIONAL: RAW SQL (ถ้าจำเป็นจริง ๆ)
  # =========================
  # ❌ ห้าม cache connection
  # ❌ ห้าม close connection เอง
  # def self.search_sql(keyword)
  #   keyword = Array(keyword).join(' ')
  #   safe = sanitize_sql_like(keyword)

  #   ActiveRecord::Base.connection_pool.with_connection do |conn|
  #     result = conn.exec_query(
  #       <<~SQL,
  #         SELECT id, username, name, role
  #         FROM users
  #         WHERE username ILIKE $1
  #           OR name ILIKE $1
  #       SQL
  #       "UserSearch",
  #       [
  #         ActiveRecord::Relation::QueryAttribute.new(
  #           "search",
  #           "%#{safe}%",
  #           ActiveRecord::Type::String.new
  #         )
  #       ]
  #     )

  #     result.rows.map do |row|
  #       instantiate(result.columns.zip(row).to_h)
  #     end
  #   end
  # end


  MAX_PER_PAGE = 100
  DEFAULT_PER_PAGE = 10
  DEFAULT_PAGE = 1


    # =========================
  # Public API
  # =========================
  def self.search_with_pagination(params)
    page     = normalize_page(params[:page])
    per_page = normalize_per_page(params[:per_page])
    offset   = (page - 1) * per_page
    keyword  = params[:keyword] # ❗ ไม่มี default

    scope = base_scope(keyword)

    {
      users: scope
               .order(id: :desc)
               .offset(offset)
               .limit(per_page),
      total: scope.count
    }
  end

  # =========================
  # Scopes
  # =========================
  scope :by_keyword, ->(keyword) {
    return all if keyword.blank?

    safe = sanitize_sql_like(keyword)

    where(
      "username ILIKE :q OR name ILIKE :q",
      q: "%#{safe}%"
    )
  }

  # =========================
  # Private helpers
  # =========================
  def self.base_scope(keyword)
    by_keyword(keyword)
  end

  def self.normalize_page(page)
    page = page.to_i
    page > 0 ? page : DEFAULT_PAGE
  end

  def self.normalize_per_page(per_page)
    per_page = per_page.to_i
    return DEFAULT_PER_PAGE if per_page <= 0
    [per_page, MAX_PER_PAGE].min
  end































  # =========================
  # PRIVATE
  # =========================
  private

  def create_cart_for_user
    create_cart!(
      total_summary: 0,
      total_amount: 0,
      status: "active"
    )
  end
end
