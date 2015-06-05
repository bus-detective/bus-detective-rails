FactoryGirl.define do
  factory :trip do
    sequence(:remote_id)
    sequence(:headsign) { |n| "Bus #{n}" }
    shape
    agency

    after(:build) do |t|
      t.service = build(:service, agency: t.agency) unless t.service
    end
  end
end
