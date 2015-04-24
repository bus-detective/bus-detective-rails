require 'rails_helper'

RSpec.describe "stops api" do
  let(:json) { JSON.parse(response.body) }

  describe "api/departures" do
    let!(:trip) { create(:trip, remote_id: 940135) }
    let!(:stop) { create(:stop, remote_id: "HAMBELi") }
    let!(:stop_time) { create(:stop_time, stop: stop, trip: trip, departure_time: 10.minutes.from_now ) }

    before do
      fixture = File.read('spec/fixtures/realtime_updates.buf')
      allow(Metro::Connection).to receive(:get).and_return(fixture)
    end

    context "with a rails id" do
      it "returns departures for a given stop" do
        get "/api/departures/?stop_id=#{stop.id}"
        expect(json["data"]["departures"].first["delay"]).to eq(120)
      end
    end

    context "with a legacy remote_id" do
      it "returns arrivals for given remote_id" do
        get "/api/departures/?stop_id=#{stop.remote_id}"
        expect(json["data"]["departures"].first["delay"]).to eq(120)
      end
    end
  end
end

