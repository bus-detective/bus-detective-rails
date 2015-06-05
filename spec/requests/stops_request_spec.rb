require 'rails_helper'

RSpec.describe "stops api" do
  let(:json) { JSON.parse(response.body) }

  describe "api/stops?name=" do
    let!(:matching_stop) { create(:stop, name: "8th and Walnut") }
    let!(:non_matching_stop) { create(:stop, name: "Somewhere else") }

    context "with a query parameter" do
      it "returns stops with the given street name" do
        get "/api/agencies/#{matching_stop.agency.id}/stops?query=8th"
        expect(json["data"]["results"].map { |s| s["id"] }).to eq([matching_stop.id])
      end
    end

    context "invalid parameters" do
      it "returns a 400" do
        get "/api/agencies/#{matching_stop.agency.id}/stops?foo=8th"
        expect(response.status).to eq(400)
      end
    end
  end

  describe "api/stops/:id" do
    let!(:stop) { create(:stop, remote_id: "HAMBELi") }

    context "with a rails id" do
      it "returns the stop" do
        get "/api/agencies/#{stop.agency.id}/stops/#{stop.id}"
        expect(json["data"]["id"]).to eq(stop.id)
      end
    end

    context "with a legacy remote_id" do
      it "returns the stop" do
        get "/api/agencies/#{stop.agency.id}/stops/#{stop.remote_id}"
        expect(json["data"]["id"]).to eq(stop.id)
      end
    end
  end
end

