FactoryBot.define do
  factory :item do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Number.within(range: 1.0..10.0) }
    merchant
  end
end