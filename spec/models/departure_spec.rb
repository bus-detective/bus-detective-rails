require 'rails_helper'

RSpec.describe Departure do
  let(:stop_time) { create(:stop_time, departure_time: Time.new) }
  subject(:departure) { Departure.new(stop_time: stop_time, stop_time_update: stop_time_update) }

  describe "time" do
    context "with no stop_time_update" do
      let(:stop_time_update) { nil }

      it "is stop_time.departure_time" do
        expect(departure.time).to eq(stop_time.departure_time)
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
