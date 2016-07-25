require 'rails_helper'

RSpec.describe Shape do
  let(:shape_points) { [[1.1, 1.2], [2.1, 2.2]] }
  let(:shape) { create(:shape, coordinates: shape_points) }

  describe "#coordinates" do
    it "returns an array of longitude, latitude doubles" do
      expect(shape.coordinates).to eq([[1.1, 1.2], [2.1, 2.2]])
    end
  end
end
