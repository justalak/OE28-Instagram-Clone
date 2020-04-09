FactoryBot.define do
  factory :bookmark_like do
    association :user

    trait :like do
      type_action {Settings.bookmark_like.like}
    end
    
    trait :bookmark do
      type_action {Settings.bookmark_like.bookmark}
    end
    
    trait :for_post do
      likeable_type{"Post"}
      association :likeable, factory: :post
    end

    trait :for_comment do
      likeable_type{"Comment"}
      association :likeable, factory: :comment
    end
  end
end
