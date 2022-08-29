FactoryBot.define do
  factory :item do
    name { Faker::Company.name }
    description { Faker::Company.name }
    unit_price { Faker::Company.name }
  end
end