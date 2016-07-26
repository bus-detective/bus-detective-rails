require 'rails_helper'

RSpec.describe "routes api" do
  let(:json) { JSON.parse(response.body) }

  describe "api/routes" do
    let!(:metro_agency) { create(:agency, name: "Metro") }
    let!(:metro_route) { create(:route, long_name: "Kings Island Express") }

    let!(:tank_agency) { create(:agency, name: "TANK") }
    let!(:tank_route) { create(:route, long_name: "Bellevue") }

    it "returns the routes for all agencies" do
      get "/api/routes"
      expect(json["routes"].map { |r| r["id"] }).to contain_exactly(metro_route.id, tank_route.id)
    end
  end
end
