FactoryBot.define do
  factory :waypoint do
    association :driving_record
    sequence(:sequence) { |n| n }
    location { "福岡県福岡市中央区天神1-1-1" }
    latitude { 33.590355 }
    longitude { 130.401716 }
  end
end
