require 'rails_helper'

RSpec.describe DepartureFetcher do
  let(:now) { Time.zone.parse("2015-04-23 07:30:00-0400") }
  let(:stop) { create(:stop) }
  let(:agency) { stop.agency }
  let(:service) { create(:service, agency: agency, thursday: true) }
  let(:trip) { create(:trip, agency: agency, service: service) }
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
    let(:departure_time) { now + 10.minutes }
    let!(:stop_time) { create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.for_time(departure_time)) }

    it "creates one for each stop_time" do
      expect(subject.departures.size).to eq(1)
    end

    it "is not realtime" do
      expect(subject.departures.first).to_not be_realtime
    end

    it "applies the departure time the scheduled stop_time" do
      expect(subject.departures.first.time).to eq(departure_time)
    end

    context "when a departure is less than 10 minutes past" do
      let(:departure_time) { now - 9.minutes }

      it "it shows already past departures for a short while" do
        expect(subject.departures.size).to eq(1)
      end
    end

    context "when a departure is up to an hour in the past" do
      let(:departure_time) { now - 55.minutes }

      it "it won't show that stop time" do
        expect(subject.departures.size).to be_zero
      end
    end

    context "when a departure is more than an hour in the past" do
      let(:departure_time) { now - 65.minutes }

      it "it won't show that stop time" do
        expect(subject.departures.size).to be_zero
      end
    end

    context "with service addition" do
      let(:service) { create(:service, agency: agency, wednesday: true) }
      let!(:service_addition) { create(:service_exception, :addition, agency: agency, service: service, date: now.to_date) }

      it "creates one for stop_time based on additional service" do
        expect(subject.departures.size).to eq(1)
      end
    end

    context "with service removal" do
      let!(:service_removal) { create(:service_exception, :removal, agency: agency, service: service, date: now.to_date) }

      it "does not find the departure" do
        expect(subject.departures.size).to eq(0)
      end
    end
  end
end

