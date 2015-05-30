FactoryGirl.define do
  factory :agency do
    name 'Test agency'
    remote_id 'TEST'
    url 'http://example.com'
    language 'en'
    timezone 'America/New_York'

    trait :with_rt_endpoint do
      gtfs_trip_updates_url 'http://example.com/gtfs'
    end
  end
end
