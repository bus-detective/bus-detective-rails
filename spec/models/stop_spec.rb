require 'rails_helper'

RSpec.describe Stop do
  describe "#routes" do
    let(:stop) { create(:stop) }
    let(:route) { create(:route) }

    let!(:trip) { create(:trip, route: route)}
    let!(:stop_time) { create(:stop_time, stop: stop, trip: trip) }

    it "associates routes to each stop" do
      expect(stop.routes).to eq([route])
    end
  end

  describe "#direction" do
    let(:stop) { build(:stop, remote_id: remote_id) }
    context "inbound" do
      let(:remote_id) { "8THWALi" }
      specify { expect(stop.direction).to eq("inbound") }
    end
    context "outbound" do
      let(:remote_id) { "8THWALo" }
      specify { expect(stop.direction).to eq("outbound") }
    end
    context "northbound" do
      let(:remote_id) { "8THWALn" }
      specify { expect(stop.direction).to eq("northbound") }
    end
    context "southbound" do
      let(:remote_id) { "8THWALs" }
      specify { expect(stop.direction).to eq("southbound") }
    end
    context "eastbound" do
      let(:remote_id) { "8THWALe" }
      specify { expect(stop.direction).to eq("eastbound") }
    end
    context "westbound" do
      let(:remote_id) { "8THWALw" }
      specify { expect(stop.direction).to eq("westbound") }
    end
    context "unknown" do
      let(:remote_id) { "8THWALR" }
      specify { expect(stop.direction).to eq(nil) }
    end
  end
end
