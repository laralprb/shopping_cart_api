class Cart < ApplicationRecord
  validates :total_price, 
    presence: true,
    numericality: { 
      greater_than_or_equal_to: 0,
      message: "must be greater than or equal to 0"
    }
  validates :last_interaction_at, presence: true
  has_many :cart_products, dependent: :destroy
  has_many :products, through: :cart_products

  scope :abandoned, -> { where.not(abandoned_at: nil) }
  scope :active, -> { where(abandoned_at: nil) }

  before_validation :set_last_interaction_at, on: :create

  def empty?
    cart_products.empty?
  end

  def total_price
    cart_products.sum { |item| item.quantity * item.product.price }
  end

  # logica para marcar o carrinho como abandonado e remover se abandonado
  def abandoned?
    abandoned_at.present?
  end

  def mark_as_abandoned
    update!(abandoned_at: last_interaction_at)
  end

  def mark_as_active
    update(abandoned_at: nil, last_interaction_at: Time.current)
  end

  def remove_if_abandoned
    destroy! if should_be_removed?
  end

  private

  def set_last_interaction_at
    self.last_interaction_at ||= Time.current
  end

  def should_be_removed?
    abandoned? && abandoned_at < 7.days.ago
  end
end
