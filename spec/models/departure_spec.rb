require 'rails_helper'

RSpec.describe Departure do
  let!(:now) { Time.zone.now }
  let(:time) { Time.zone.parse("2015-04-23 7:30") }
  let(:stop_time) { create(:stop_time, departure_time: Interval.for_time(time)) }

  subject(:departure) { Departure.new(date: time.to_date, stop_time: stop_time, stop_time_update: stop_time_update) }

  context "with no stop_time_update" do
    let(:stop_time_update) { nil }

    it "has the time of the scheduled departure_time" do
      expect(departure.time).to eq(stop_time.departure_time_on(time))
    end

    it "applies the date to the stop_time (because the database resets it to 2000-01-01)" do
      stop_time.reload
      expect(departure.time).to eq(time)
    end

    it "is not realtime" do
      expect(departure).not_to be_realtime
    end

    it "has no delay" do
      expect(departure.delay).to eq(0)
    end

    it "calculates the duration from the scheduled departure time" do
      expect(departure.duration_from(time)).to eq(Interval.new(0))
    end

    context "with a scheduled time in the past" do
      let(:time) { now - 5.minutes }

      it "can calculate the duration from the scheduled departure time in the past" do
        expect(departure.duration_from(now)).to eq(Interval.new(-5.minutes))
      end
    end

    context "When time could span across a dateline" do
      let(:time) { Time.zone.parse("2015-04-23 23:00") }

      it "maintains the correct date" do
        stop_time.reload
        expect(departure.time).to eq(time)
      end
    end
  end

  context "with a stop_time_update" do
    let(:time) { now + 10.minutes }
    let(:stop_time_update) { OpenStruct.new(departure_time: time, delay: 10) }

    it "has the time of the realtime departure_time" do
      expect(departure.time).to eq(stop_time_update.departure_time)
    end

    it "is realtime" do
      expect(departure).to be_realtime
    end

    it "has a delay" do
      expect(departure.delay).to eq(10)
    end

    it "can calculate the duration from the realtime departure time" do
      expect(departure.duration_from(now)).to eq(Interval.new(10.minutes))
    end

    context "with a departure time in the past" do
      let(:time) { now - 5.minutes }

      it "can calculate the duration from the scheduled departure time in the past" do
        expect(departure.duration_from(now)).to eq(Interval.new(-5.minutes))
      end
    end
  end
end

