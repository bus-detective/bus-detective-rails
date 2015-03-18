require 'rails_helper'

RSpec.describe Arrival do
  let!(:stop) { create(:stop, stop_id: "WAL8THi") }
  let!(:trip) { create(:trip, trip_id: 956729) }
  let!(:route) { create(:route, route_id: 17) }
  let(:realtime_arrival) { {
    stop_id: "WAL8THi",
    trip_id: "956729",
    route_id: "17",
    stop_sequence: 80,
    time: Time.new,
    delay: 60,
  } }

  subject(:arrival) { Arrival.new(realtime_arrival) }

  it "has a stop" do
    expect(arrival.stop).to eq(stop)
  end

  it "has a route" do
    expect(arrival.route).to eq(route)
  end

  it "has a trip" do
    expect(arrival.trip).to eq(trip)
  end
end
