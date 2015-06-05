FactoryGirl.define do
  factory :shape_point do
    shape
    latitude 1.5
    longitude 1.5
    sequence(:sequence) { |n| n }
    distance_traveled 1.5
  end
end
