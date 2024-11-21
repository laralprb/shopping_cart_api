class CartProduct < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  after_initialize :set_default_quantity
  after_commit :update_cart_total

  private

  def set_default_quantity
    self.quantity ||= 0 if new_record?
  end

  def update_cart_total
    cart.save if cart.present?
  end
end
