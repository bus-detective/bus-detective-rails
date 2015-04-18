require 'rails_helper'

RSpec.describe "arrivals api" do
  let!(:stop) { create(:stop, remote_id: "HAMBELi") }
  let!(:trip) { create(:trip, remote_id: 940135) }
  let!(:route) { create(:route, remote_id: 17) }
  let(:json) { JSON.parse(response.body) }

  before do
    fixture = File.read('spec/fixtures/arrivals.buf')
    allow(Metro::Connection).to receive(:get).and_return(fixture)
  end

  describe "api/arrivals/:id" do
    it "returns arrivals for a given stop id" do
      get '/api/arrivals/HAMBELi'
      expect(json["arrivals"].first["route_id"]).to eq(17)
    end
  end
end
