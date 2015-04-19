require 'rails_helper'

RSpec.describe "stops api" do
  let(:json) { JSON.parse(response.body) }
  let(:stop_ids) {  json["data"]["results"].map { |s| s["id"] } }

  describe "api/stops?name=" do
    let!(:matching_stop) { create(:stop, name: "8th and Walnut") }
    let!(:non_matching_stop) { create(:stop, name: "Somewhere else") }

    context "with a query parameter" do
      it "returns stops with the given street name" do
        get '/api/stops?query=8th'
        expect(stop_ids).to eq([matching_stop.id])
      end
    end

    context "invalid parameters" do
      it "returns a 400" do
        get '/api/stops?foo=8th'
        expect(response.status).to eq(400)
      end
    end
  end
end

