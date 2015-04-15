require 'rails_helper'

RSpec.describe "stops api" do
  let(:json) { JSON.parse(response.body) }
  let(:stop_ids) {  json["stops"].map { |s| s["id"] } }

  describe "api/stops?name=" do
    let!(:matching_stop) { create(:stop, name: "8th and Walnut") }
    let!(:non_matching_stop) { create(:stop, name: "Somewhere else") }

    it "returns stops with the given street name" do
      get '/api/stops?query=8th'
      expect(stop_ids).to eq([matching_stop.id])
    end

      expect(stop_ids).to eq([matching_stop.id])
    end
  end
end

