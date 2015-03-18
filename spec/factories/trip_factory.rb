FactoryGirl.define do
  factory :trip do
    sequence(:headsign) { |n| "Bus #{n}" }
  end
end
