FactoryBot.define do
  factory :post do
    description {Faker::Lorem.sentence}
    association :user

    trait :with_hashtags do
      description {"#rspec"}
    end
    after(:build) do |post|
      post.images.attach(io: File.open(Rails.root.join("app", "assets", "images", "default.jpg")), filename: "default.jpg", content_type: 'image/jpeg')
    end
  end
end
