FactoryBot.define do
  factory :cart, aliases: [:shopping_cart] do
    last_interaction_at { Time.current }
    total_price { 0 }

    trait :abandoned do
      abandoned_at { 3.hours.ago }
    end

    trait :old_abandoned do
      abandoned_at { 8.days.ago }
    end
  end
end 