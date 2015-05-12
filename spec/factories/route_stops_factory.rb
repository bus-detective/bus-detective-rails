FactoryGirl.define do
  factory :route_stop do
    after(:build) do |rs|
      agency = build(:agency)
      rs.route = build(:route, agency: agency) unless rs.route
      rs.stop = build(:stop, agency: agency) unless rs.stop
    end
  end
end
