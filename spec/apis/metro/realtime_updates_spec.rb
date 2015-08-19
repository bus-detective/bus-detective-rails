require 'rails_helper'
require 'protobuf'

RSpec.describe Metro::RealtimeUpdates do
  let(:fixture) { File.read('spec/fixtures/realtime_updates.buf') }
  let(:agency) { create(:agency, :with_rt_endpoint) }
  subject { Metro::RealtimeUpdates.new(fixture) }

  before do
    allow(Metro::Connection).to receive(:get).with(agency.gtfs_trip_updates_url).and_return(fixture)
  end

  describe "#fetch" do
    it "calls Connection.get with the endpoint" do
      Metro::RealtimeUpdates.fetch(agency)
      expect(Metro::Connection).to have_received(:get).with(agency.gtfs_trip_updates_url)
    end
  end

  describe "#for_trip" do
    let(:trip_update) { subject.for_trip(trip) }

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
        expect(subject.for_trip(trip)).to be_nil
      end
    end
  end

  describe "#for_stop_time" do
    let(:stop_time_update) { subject.for_stop_time(stop_time) }

    context "with a matching stop_time.trip.remote_id and stop_time.stop.remote.id" do
      let!(:trip) { build(:trip, remote_id: 940135) }
      let!(:stop) { build(:stop, remote_id: "HAMBELi") }
      let!(:stop_time) { build(:stop_time, stop: stop, trip: trip, departure_time: Interval.for_time(10.minutes.from_now).to_s ) }

      it "returns a StopTimeUpdate for the stop_time" do
        expect(stop_time_update).to be_a(Metro::RealtimeUpdates::StopTimeUpdate)
        expect(stop_time_update.stop_id).to eq(stop.remote_id)
      end
    end

    context "with stop_sequence after one of the given updates" do
      let!(:trip) { build(:trip, remote_id: 940135) }
      let!(:stop) { build(:stop, remote_id: "NA") }
      let!(:stop_time) { build(:stop_time, stop: stop, trip: trip, stop_sequence: 99, departure_time: Interval.for_time(10.minutes.from_now).to_s ) }

      it "interprets the delay as the delay from the previous stop_sequence" do
        expect(stop_time_update).to be_a(Metro::RealtimeUpdates::StopTimeUpdate)
        expect(stop_time_update.stop_sequence).to eq(97)
        expect(stop_time_update.delay).to eq(120)
      end
    end

    context "with a non-matching stop_time" do
      let(:stop_time) { build(:stop_time) }
      it "returns nil" do
        expect(subject.for_stop_time(stop_time)).to be_nil
      end
    end
  end

  context 'with an invalid feed' do
    before do
      expect(Transit_realtime::FeedMessage).to receive(:new).and_raise(Protobuf::Error)
    end

    it 'throws a Metro::Error' do
      expect { Metro::RealtimeUpdates.new(fixture) }.to raise_error(Metro::Error)
    end
  end
end
