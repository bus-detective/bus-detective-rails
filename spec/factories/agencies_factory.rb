FactoryGirl.define do
  factory :agency do
    name 'Test agency'
    remote_id 'TEST'
    url 'http://example.com'
    language 'en'
    timezone 'America/New_York'

    trait :with_rt_endpoint do
      realtime_endpoint 'http://example.com/gtfs'
    end
  end
end
