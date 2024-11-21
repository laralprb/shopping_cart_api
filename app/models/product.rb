class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, 
    presence: { message: "can't be blank" },
    numericality: { 
      greater_than_or_equal_to: 0,
      message: "must be greater than or equal to 0"
    }
  has_many :cart_products
  has_many :carts, through: :cart_products

  alias_attribute :price, :unit_price

  def price=(value)
    self.unit_price = value
  end

  def price
    unit_price
  end
end
