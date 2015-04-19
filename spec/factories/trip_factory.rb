FactoryGirl.define do
  factory :trip do
    sequence(:remote_id)
    sequence(:headsign) { |n| "Bus #{n}" }
  end
end
