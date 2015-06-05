require 'rails_helper'

RSpec.describe "trips api" do
  let(:json) { JSON.parse(response.body) }

  describe "api/trips?route_id=11" do
    let!(:route) { create(:route) }
    let!(:matching_trip) { create(:trip, agency: route.agency, route: route) }
    let!(:non_matching_trip) { create(:trip, agency: route.agency) }

    context "with a valid route_id" do
      it "returns trip data for the given route id" do
        get "/api/agencies/#{route.agency.id}/trips?route_id=#{route.id}"
        expect(json["data"]["results"].map { |s| s["id"] }).to eq([matching_trip.id])
      end
    end

    context "with invalid parameters" do
      it "returns a 400" do
        get "/api/agencies/#{route.agency.id}/trips?foo=bar"
        expect(response.status).to eq(400)
      end
    end
  end

  describe "api/trips?trip_id=11" do
    let!(:trip) { create(:trip) }
    let!(:non_matching_trip) { create(:trip) }

    before do
      get "/api/agencies/#{trip.agency.id}/trips?trip_id=#{trip.id}"
    end

    context "with a valid trip_id" do
      let(:trip_json) { json["data"]["results"].first }

      it "returns trip data for the given trip id" do
        expect(trip_json['id']).to eq(trip.id)
      end

      it "returns shape_id data for the given trip id" do
        expect(trip_json['shape_id'].to_i).to eq(trip.shape_id)
      end
    end
  end
end


