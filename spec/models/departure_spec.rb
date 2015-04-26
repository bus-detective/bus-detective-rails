require 'rails_helper'

RSpec.describe Departure do
  let(:time) { Time.zone.parse("2015-04-23 7:30") }
  let(:stop_time) { create(:stop_time, departure_time: time) }
  subject(:departure) { Departure.new(date: time.to_date, stop_time: stop_time, stop_time_update: stop_time_update) }

  describe "time" do
    context "with no stop_time_update" do
      let(:stop_time_update) { nil }

      it "is stop_time.departure_time" do
        expect(departure.time).to eq(stop_time.departure_time)
      end

      it "applies the date to the stop_time (because the database resets it to 2000-01-01)" do
        stop_time.reload
        expect(departure.time).to eq(time)
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
      let(:stop_time_update) { OpenStruct.new(departure_time: Time.new) }

      it "is stop_time_update.departure_time" do
        expect(departure.time).to eq(stop_time_update.departure_time)
      end
    end
  end

  describe "realtime?" do
    context "with no stop_time_update" do
      let(:stop_time_update) { nil }

      it "is false" do
        expect(departure.realtime?).to eq(false)
      end
    end

    context "with a stop_time_update" do
      let(:stop_time_update) { OpenStruct.new(departure_time: Time.new) }

      it "is true" do
        expect(departure.realtime?).to eq(true)
      end
    end
  end

  describe "delay" do
    context "with no stop_time_update" do
      let(:stop_time_update) { nil }

      it "is false" do
        expect(departure.delay).to eq(0)
      end
    end

    context "with a delayed stop_time_update" do
      let(:stop_time_update) { OpenStruct.new(departure_time: Time.new, delay: 10) }

      it "is true" do
        expect(departure.delay).to eq(10)
      end
    end
  end
end
