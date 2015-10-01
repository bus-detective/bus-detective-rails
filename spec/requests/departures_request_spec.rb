require 'rails_helper'

RSpec.describe "departures api" do
  let(:json) { JSON.parse(response.body) }
  let(:now) { Time.zone.parse("2015-02-16 17:55:00 -0500") }
  let!(:trip) { create(:trip, agency: agency, remote_id: 940135, service: create(:service, agency: agency, monday: true)) }
  let!(:stop) { create(:stop, agency: agency, remote_id: "HAMBELi") }
  let!(:stop_times) {
    [
      create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.for_time(now + 10.minutes)),
      create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.for_time(now + 2.hours)),
      create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.for_time(now + 2.hours + 1.second)),
    ]
  }

  before do
    fixture = File.read('spec/fixtures/realtime_updates.buf')
    allow(Metro::Connection).to receive(:get).and_return(fixture)
  end

  describe "api/departures for agency without realtime data" do
    let(:agency) { create(:agency) }

    context "with a rails id" do
      it "returns departures for a given stop" do
        get "/api/departures/?stop_id=#{stop.id}&time=#{now}"
        expect(json["data"]["departures"].first["delay"]).to eq(0)
      end
    end

    context "with a legacy remote_id" do
      it "returns arrivals for given remote_id" do
        get "/api/departures/?stop_id=#{stop.remote_id}&time=#{now}"
        expect(json["data"]["departures"].first["delay"]).to eq(0)
      end
    end

    context "with a duration" do
      it "returns stops with an end time N hours in the future" do
        get "/api/departures", stop_id: stop.id, time: now, duration: 2
        expect(json["data"]["departures"].length).to eq(2)
      end
    end

    context "missing a stop id" do
      it "responds with a bad request" do
        get "/api/departures/?stop_id=&time=#{now}"
        expect(response).to be_bad_request
      end
    end
  end

  describe "api/departures for agency with realtime data" do
    let(:agency) { create(:agency, :with_rt_endpoint) }

    context "with a rails id" do
      it "returns departures for a given stop" do
        get "/api/departures/?stop_id=#{stop.id}&time=#{now}"
        expect(json["data"]["departures"].first["delay"]).to eq(120)
      end
    end

    context "with a legacy remote_id" do
      it "returns arrivals for given remote_id" do
        get "/api/departures/?stop_id=#{stop.remote_id}&time=#{now}"
        expect(json["data"]["departures"].first["delay"]).to eq(120)
      end
    end

    context "missing a stop id" do
      it "responds with a bad request" do
        get "/api/departures/?stop_id=&time=#{now}"
        expect(response).to be_bad_request
      end
    end
  end
end

