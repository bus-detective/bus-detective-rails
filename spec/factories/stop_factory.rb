FactoryGirl.define do
  factory :stop do
    name "Test stop"
    sequence(:remote_id)
    agency
  end
end
