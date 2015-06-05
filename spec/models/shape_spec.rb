require 'rails_helper'

RSpec.describe Shape do
  let(:shape_point2) { create(:shape_point, latitude: 2.1, longitude: 2.2, sequence: 2) }
  let(:shape_point1) { create(:shape_point, latitude: 1.1, longitude: 1.2, sequence: 1) }
  let(:shape) { create(:shape, shape_points: [shape_point1, shape_point2]) }

  describe "#coordinates" do
    it "returns an array of longitude, latitude doubles" do
      expect(shape.coordinates).to eq([[1.1, 1.2], [2.1, 2.2]])
    end
  end
end
