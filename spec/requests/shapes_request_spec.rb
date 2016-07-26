require 'rails_helper'

RSpec.describe "shapes api" do
  let(:json) { JSON.parse(response.body) }

  describe "api/shapes/:id" do
    let!(:shape) { create(:shape, coordinates: [[1.5, 1.5], [1.5, 1.5], [1.5, 1.5], [1.5, 1.5], [1.5, 1.5], [1.5, 1.5], [1.5, 1.5], [1.5, 1.5], [1.5, 1.5], [1.5, 1.5]]) }
    before do
      get "/api/shapes/#{shape.id}"
    end

    context "with a rails id" do
      it "returns the shape" do
        expect(json["data"]["id"]).to eq(shape.id)
      end

      it "returns the shape geojson" do
        expect(json["data"]["type"]).to eq('LineString')
        expect(json["data"]["coordinates"].size).to eq(10)
      end
    end
  end
end


