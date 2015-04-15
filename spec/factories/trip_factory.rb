FactoryGirl.define do
  factory :trip do
    sequence(:trip_id)
    sequence(:headsign) { |n| "Bus #{n}" }
  end
end
