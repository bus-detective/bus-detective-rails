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

  describe "api/trips?trip_id=11" do
    let!(:non_matching_trip) { create(:trip) }
    let!(:trip) { create(:trip) }

    before do
      get "/api/trips?trip_id=#{trip.id}"
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

  describe "api/trips?ids[]=1&ids[]=2" do
    let(:trips) { create_list(:trip, 3) }

    before do
      query_string = trips.map { |s| "ids[]=#{s.id}" }.join("&")
      get("/api/trips?#{query_string}")
    end

    it "returns an array of trips" do
      response_ids = json["data"]["results"].map { |s| s["id"] }
      expect(response_ids).to eq(trips.map(&:id))
    end
  end
end


