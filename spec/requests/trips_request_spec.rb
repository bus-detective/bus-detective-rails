require 'rails_helper'

RSpec.describe "trips api" do
  let(:json) { JSON.parse(response.body) }

  describe "api/trips?route_id=11" do
    let!(:route) { create(:route) }
    let!(:matching_trip) { create(:trip, route: route) }
    let!(:non_matching_trip) { create(:trip) }

    context "with a valid route_id" do
      it "returns trip data for the given route id" do
        get "/api/trips?route_id=#{route.id}"
        expect(json["data"]["results"].map { |s| s["id"] }).to eq([matching_trip.id])
      end
    end

    context "with invalid parameters" do
      it "returns a 400" do
        get '/api/trips?foo=bar'
        expect(response.status).to eq(400)
      end
    end
  end
end


