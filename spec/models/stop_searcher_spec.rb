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
end
