FactoryBot.define do
  factory :relationship do
    association :follower_id, factory: :user
    association :followed_id, factory: :user
  end
end
