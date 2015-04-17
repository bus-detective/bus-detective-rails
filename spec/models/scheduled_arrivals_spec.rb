require 'rails_helper'

RSpec.describe ScheduledArrivals do
  let!(:stop) { create(:stop, remote_id: "8THWALi") }
  let!(:trip) { create(:trip, remote_id: 939599) }

  before do
    fake_arrivals = Metro::RealtimeArrivals.new(File.read("spec/fixtures/arrivals.buf"))
    allow(Metro::Connection).to receive(:realtime_arrivals).and_return(fake_arrivals)
  end

  describe "#for_stop" do
    it "returns scheduled arrivals for a given stop_id" do
      scheduled_arrivals = ScheduledArrivals.for_stop(stop)
      expect(scheduled_arrivals.first.trip).to eq(trip)
    end
  end
end

