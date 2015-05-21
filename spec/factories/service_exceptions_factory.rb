FactoryGirl.define do
  factory :service_exception do
    service
    date { Date.today }

    trait :addition do
      exception 1
    end

    trait :removal do
      exception 2
    end

    after(:build) do |se|
      se.agency = service.agency unless se.agency
    end
  end
end

