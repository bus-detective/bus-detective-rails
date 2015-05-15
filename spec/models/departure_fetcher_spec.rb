require 'rails_helper'

RSpec.describe DepartureFetcher do
  let(:now) { Time.zone.parse("2015-04-23 7:30am") }
  let(:stop) { create(:stop) }
  let(:agency) { stop.agency }
  let(:trip) { create(:trip, agency: agency, service: create(:service, agency: agency, thursday: true)) }
  subject { DepartureFetcher.new(agency, stop, now) }

  describe "#stop_times" do
    let!(:applicable_stop_time) {
      create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.for_time(now + 10.minutes))
    }
    let!(:out_of_time_range_stop_time) {
      create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.for_time(now - 2.hours))
    }
    let!(:different_service_stop_time) {
      create(:stop_time, agency: agency, stop: stop, trip: create(:trip, agency: agency), departure_time: Interval.for_time(now))
    }

    it "searches stop_times within a time range and on the service" do
      expect(subject.stop_times).to eq([applicable_stop_time])
    end
  end

  describe "departures without realtime updates" do
    let(:departure_time) { Interval.for_time(now + 10.minutes) }
    let!(:stop_time) { create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: departure_time) }

    it "creates one for each stop_time" do
      expect(subject.departures.size).to eq(1)
    end

    it "is not realtime" do
      expect(subject.departures.first).to_not be_realtime
    end

    it "applies the departure time the scheduled stop_time" do
      expect(subject.departures.first.time).to eq(stop_time.departure_time_on(now))
    end

    context "when a departure is less than 10 minutes past" do
      let(:departure_time) { Interval.for_time(now - 9.minutes) }

      it "it shows already past departures for a short while" do
        expect(subject.departures.size).to eq(1)
      end
    end

    context "when a departure is up to an hour in the past" do
      let(:departure_time) { Interval.for_time(now - 55.minutes) }

      it "it won't show that stop time" do
        expect(subject.departures.size).to be_zero
      end
    end

    context "when a departure is more than an hour in the past" do
      let(:departure_time) { Interval.for_time(now - 65.minutes) }

      it "it won't show that stop time" do
        expect(subject.departures.size).to be_zero
      end
    end
  end
end

