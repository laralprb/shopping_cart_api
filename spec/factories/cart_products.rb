FactoryBot.define do
  factory :cart_product do
    cart
    product
    quantity { nil }
  end
end 