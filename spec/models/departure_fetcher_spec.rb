require 'rails_helper'

RSpec.describe DepartureFetcher do
  let(:now) { Time.zone.parse("2015-04-23 7:30am") }
  let(:stop) { create(:stop) }
  let(:trip) { create(:trip, service: create(:service, thursday: true)) }
  subject(:stop_time_fetcher) { DepartureFetcher.new(params) }

  describe "#stop_times" do
    let!(:applicable_stop_time) {
      create(:stop_time, stop: stop, trip: trip, departure_time: now + 10.minutes)
    }
    let!(:out_of_time_range_stop_time) {
      create(:stop_time, stop: stop, trip: trip, departure_time: now - 2.hours)
    }
    let!(:different_service_stop_time) {
      create(:stop_time, stop: stop, trip: create(:trip), departure_time: now)
    }
    let(:params) { { stop_id: stop.id, time: now.to_s } }

    it "searches stop_times within a time range and on the service" do
      expect(stop_time_fetcher.stop_times).to eq([applicable_stop_time])
    end
  end

  describe "#departures" do
    let!(:stop_time) { create(:stop_time, stop: stop, trip: trip, departure_time: now + 10.minutes) }
    let(:params) { { stop_id: stop.id, time: now.to_s } }
    let(:fake_realtime_updates) { double("RealtimeUpdates", for_stop_time: fake_stop_time_update) }

    before do
      allow(Metro::RealtimeUpdates).to receive(:fetch).and_return(fake_realtime_updates)
    end

    context "when an associated realtime update exists for the stop time" do
      let(:fake_stop_time_update) { OpenStruct.new(departure_time: now + 15.minutes) }

      it "creates one for each stop_time" do
        expect(stop_time_fetcher.departures.size).to eq(1)
      end

      it "is realtime" do
        expect(stop_time_fetcher.departures.first).to be_realtime
      end

      it "applies the departure time from the realtime update" do
        expect(stop_time_fetcher.departures.first.time).to eq(fake_stop_time_update.departure_time)
      end
    end

    context "when an associated realtime update does not exist for the stop time" do
      let(:fake_stop_time_update) { nil }

      it "creates one for each stop_time" do
        expect(stop_time_fetcher.departures.size).to eq(1)
      end

      it "is not realtime" do
        expect(stop_time_fetcher.departures.first).to_not be_realtime
      end

      it "applies the departure time the scheduled stop_time" do
        expect(stop_time_fetcher.departures.first.time).to eq(stop_time.departure_time)
      end
    end
  end
end
