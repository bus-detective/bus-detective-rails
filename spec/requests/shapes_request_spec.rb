require 'rails_helper'

RSpec.describe "shapes api" do
  let(:json) { JSON.parse(response.body) }

  describe "api/shapes" do
    let(:shapes) { create_list(:shape, 3) }

    context "without an ids array" do
      before do
        get("/api/shapes")
      end

      it "400s" do
        expect(response.status).to eq(400)
      end
    end

    context "with an ids array" do
      before do
        query_string = shapes.map { |s| "ids[]=#{s.id}" }.join("&")
        get("/api/shapes?#{query_string}")
      end

      it "returns an array of shapes" do
        response_ids = json["data"]["results"].map { |s| s["id"] }
        expect(response_ids).to eq(shapes.map(&:id))
      end
    end
  end

  describe "api/shapes/:id" do
    let!(:shape) { create(:shape) }
    let!(:shape_points) { create_list(:shape_point, 10, shape: shape) }

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


