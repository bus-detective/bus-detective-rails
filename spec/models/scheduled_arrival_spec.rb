require 'rails_helper'

RSpec.describe "TODO" do
  let!(:stop) { create(:stop, stop_id: "8THWALi") }
  let!(:route) { create(:route, route_id: 11) }
  let!(:trip) { create(:trip, trip_id: 123, route: route) }
  let!(:stop_time) { create(:stop_time, stop: stop, trip: trip, arrival_time: "8:00:00") }

  describe "arrivals" do
    it "returns scheduled arrivals for a given stop_id" do
      scheduled_arrivals = ScheduledArrival.search("8THWALi")
      expect(scheduled_arrivals.first.route_id).to eq(11)
    end
  end
end

