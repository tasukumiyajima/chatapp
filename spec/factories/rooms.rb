FactoryBot.define do
  factory :room do
    sequence(:name) { |n| "testroom#{n}" }
  end
end
