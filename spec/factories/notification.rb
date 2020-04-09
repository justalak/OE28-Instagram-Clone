FactoryBot.define do
  factory :notification do
    association :sender, factory: :user
    association :receiver, factory: :user
    association :post
  end
end
