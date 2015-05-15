FactoryGirl.define do
  factory :route do
    sequence(:remote_id)
    agency
  end
end
