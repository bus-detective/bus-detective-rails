require 'rails_helper'

RSpec.describe "arrivals api" do
  let!(:stop) { create(:stop, stop_id: "HAMBELi") }
  let!(:trip) { create(:trip, trip_id: 940135) }
  let!(:route) { create(:route, route_id: 17) }
  let(:json) { JSON.parse(response.body) }

  before do
    fixture = File.read('spec/fixtures/arrivals.buf')
    allow(Metro::Connection).to receive(:get).and_return(fixture)
  end

  describe "api/arrivals" do
    it "returns all arrivals" do
      get '/api/arrivals'
      expect(json["arrivals"].first["route_id"]).to eq("64")
    end
  end

  describe "api/arrivals/:id" do
    it "returns arrivals for a given stop id" do
      get '/api/arrivals/HAMBELi'
      puts json["arrivals"].length
      expect(json["arrivals"].first["route_id"]).to eq(17)
    end
  end
end
