require 'rails_helper'

RSpec.describe Metro::RealtimeUpdates do
  let(:fixture) { File.read('spec/fixtures/realtime_updates.buf') }
  subject(:realtime_updates) { Metro::RealtimeUpdates.new(fixture) }

  describe "#fetch" do
    it "calls Connection.get with the endpoint" do
      allow(Metro::Connection).to receive(:get).and_return(fixture)
      Metro::RealtimeUpdates.fetch
      expect(Metro::Connection).to have_received(:get).with(Metro::RealtimeUpdates::ENDPOINT)
    end
  end

  describe "#for_trip" do
    let(:trip_update) { realtime_updates.for_trip(trip) }

    context "with a matching trip.remote_id" do
      let(:trip) { build(:trip, remote_id: 940135) }
      it "returns a TripUpdate for the trip" do
        expect(trip_update).to be_a(Metro::RealtimeUpdates::TripUpdate)
        expect(trip_update.trip_id).to eq(trip.remote_id.to_s)
      end
    end

    context "with a non-matching trip.remote_id" do
      let(:trip) { build(:trip, remote_id: 999999) }
      it "returns nil" do
        expect(realtime_updates.for_trip(trip)).to be_nil
      end
    end
  end

  describe "#for_stop_time" do
    let(:stop_time_update) { realtime_updates.for_stop_time(stop_time) }

    context "with a matching stop_time.trip.remote_id and stop_time.stop.remote.id" do
      let!(:trip) { build(:trip, remote_id: 940135) }
      let!(:stop) { build(:stop, remote_id: "HAMBELi") }
      let!(:stop_time) { build(:stop_time, stop: stop, trip: trip, departure_time: 10.minutes.from_now ) }

      it "returns a StopTimeUpdate for the stop_time" do
        expect(stop_time_update).to be_a(Metro::RealtimeUpdates::StopTimeUpdate)
        expect(stop_time_update.stop_id).to eq(stop.remote_id)
      end
    end

    context "with a non-matching stop_time" do
      let(:stop_time) { build(:stop_time) }
      it "returns nil" do
        expect(realtime_updates.for_stop_time(stop_time)).to be_nil
      end
    end
  end
end
