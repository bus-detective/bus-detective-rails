require 'rails_helper'

describe StopSearcher do
  subject(:stop_searcher) { StopSearcher.new(params) }

  context "with a name" do
    let!(:matching_stop) { create(:stop, name: "8th and Walnut") }
    let!(:non_matching_stop) { create(:stop, name: "7th and Main") }
    let(:params) { { name: "walnut" } }

    it "returns stops matching the given name" do
      expect(stop_searcher.stops).to eq([matching_stop])
    end
  end

  context "with a latitude and longitude" do
    let!(:far_stop) { create(:stop, latitude: 38.104836, longitude: -85.511653) }
    let!(:near_stop) { create(:stop, latitude: 39.104836, longitude: -84.511653) }
    let(:params) { { latitude: "39.1043200", longitude: "-84.5118910" } }

    it "returns stops matching the given name" do
      expect(stop_searcher.stops).to eq([near_stop, far_stop])
    end
  end
end