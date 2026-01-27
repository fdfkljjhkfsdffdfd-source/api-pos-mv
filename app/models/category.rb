class Category < ApplicationRecord
    has_many :sku_masters
    validates :name, presence: true, uniqueness: true

end
