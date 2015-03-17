require 'rails_helper'

RSpec.describe "arrivals api" do
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
      get '/api/arrivals/8THWALi'
      expect(json["arrivals"].first["route_id"]).to eq("11")
    end
  end
end
