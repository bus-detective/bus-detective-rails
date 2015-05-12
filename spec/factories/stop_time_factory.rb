FactoryGirl.define do
  factory :stop_time do
    agency

    after(:build) do |st|
      st.stop = build(:stop, agency: st.agency) unless st.stop
      st.trip = build(:trip, agency: st.agency) unless st.trip
    end
  end
end
