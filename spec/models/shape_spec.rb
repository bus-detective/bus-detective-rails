require 'rails_helper'

RSpec.describe Shape do
  let(:shape_point2) { build(:shape_point, latitude: 2.1, longitude: 2.2, sequence: 2) }
  let(:shape_point1) { build(:shape_point, latitude: 1.1, longitude: 1.2, sequence: 1) }
  let(:shape) { build(:shape, shape_points: [shape_point1, shape_point2]) }

  describe "#coordinates" do
    it "returns an array of lat, lng douples" do
      expect(shape.coordinates).to eq([[1.1, 1.2], [2.1, 2.2]])
    end
  end
end
