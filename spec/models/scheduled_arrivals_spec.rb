require 'rails_helper'

RSpec.describe ScheduledArrivals do
  let!(:stop) { create(:stop, stop_id: "8THWALi") }
  let!(:trip) { create(:trip, trip_id: 939599) }

  before do
    fake_arrivals = Metro::Arrivals.new(File.read("spec/fixtures/arrivals.buf"))
    allow(Metro::Connection).to receive(:arrivals).and_return(fake_arrivals)
  end

  describe "#for_stop" do
    it "returns scheduled arrivals for a given stop_id" do
      scheduled_arrivals = ScheduledArrivals.for_stop("8THWALi")
      expect(scheduled_arrivals.first[:trip]).to eq(trip)
    end
  end
end

