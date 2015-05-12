require 'rails_helper'

RSpec.describe RealtimeDepartureFetcher do
  let(:now) { Time.zone.parse("2015-04-23 7:30am") }
  let(:agency) { create(:agency, :with_rt_endpoint) }
  let(:stop) { create(:stop, agency: agency) }
  let(:trip) { create(:trip, agency: agency, service: create(:service, agency: agency, thursday: true)) }
  subject { RealtimeDepartureFetcher.new(agency, stop, now) }

  describe "#stop_times" do
    let!(:applicable_stop_time) {
      create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: now + 10.minutes)
    }
    let!(:out_of_time_range_stop_time) {
      create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: now - 2.hours)
    }
    let!(:different_service_stop_time) {
      create(:stop_time, agency: agency, stop: stop, trip: create(:trip, agency: agency), departure_time: now)
    }

    it "searches stop_times within a time range and on the service" do
      expect(subject.stop_times).to eq([applicable_stop_time])
    end
  end

  describe "#departures" do
    let(:departure_time) { now + 10.minutes }
    let!(:stop_time) { create(:stop_time, agency:agency, stop: stop, trip: trip, departure_time: departure_time) }
    let(:fake_realtime_updates) { double("RealtimeUpdates", for_stop_time: fake_stop_time_update) }

    before do
      allow(Metro::RealtimeUpdates).to receive(:fetch).with(agency).and_return(fake_realtime_updates)
    end

    context "when an associated realtime update exists for the stop time" do
      let(:fake_stop_time_update) { OpenStruct.new(departure_time: now + 15.minutes) }

      it "creates one for each stop_time" do
        expect(subject.departures.size).to eq(1)
      end

      it "is realtime" do
        expect(subject.departures.first).to be_realtime
      end

      it "applies the departure time from the realtime update" do
        expect(subject.departures.first.time).to eq(fake_stop_time_update.departure_time)
      end
    end

    context "when an associated realtime update does not exist for the stop time" do
      let(:fake_stop_time_update) { nil }

      it "creates one for each stop_time" do
        expect(subject.departures.size).to eq(1)
      end

      it "is not realtime" do
        expect(subject.departures.first).to_not be_realtime
      end

      it "applies the departure time the scheduled stop_time" do
        expect(subject.departures.first.time).to eq(stop_time.departure_time)
      end
    end

    context "when a departure is less than 10 minutes past" do
      let(:departure_time) { now - 9.minutes }

      context "and realtime updates are in the past for the stop time" do
        let(:fake_stop_time_update) { OpenStruct.new(departure_time: now - 9.minutes) }

        it "it shows already past departures for a short while" do
          expect(subject.departures.size).to eq(1)
        end
      end

      context "and realtime updates do not exist for the stop time" do
        let(:fake_stop_time_update) { nil }

        it "it shows already past departures for a short while" do
          expect(subject.departures.size).to eq(1)
        end
      end
    end

    context "when a departure is up to an hour in the past" do
      let(:departure_time) { now - 55.minutes }

      context "and realtime updates are available showing upcoming departure for the stop time" do
        let(:fake_stop_time_update) { OpenStruct.new(departure_time: now + 5.minutes) }

        it "it shows late departures up to an hour past due" do
          expect(subject.departures.size).to eq(1)
        end
      end

      context "and realtime updates do not exist for the stop time" do
        let(:fake_stop_time_update) { nil }

        it "it won't show that stop time" do
          expect(subject.departures.size).to be_zero
        end
      end
    end

    context "when a departure is more than an hour in the past" do
      let(:departure_time) { now - 65.minutes }

      context "and realtime updates are available showing upcoming departure for the stop time" do
        let(:fake_stop_time_update) { OpenStruct.new(departure_time: now + 5.minutes) }

        it "it won't show that stop time" do
          expect(subject.departures.size).to be_zero
        end
      end

      context "and realtime updates do not exist for the stop time" do
        let(:fake_stop_time_update) { nil }

        it "it won't show that stop time" do
          expect(subject.departures.size).to be_zero
        end
      end
    end
  end
end
