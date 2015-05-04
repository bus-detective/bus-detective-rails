require 'rails_helper'

describe StopSearcher do
  subject(:stop_searcher) { StopSearcher.new(params) }

  describe "#valid?" do
    context "with invalid parameters" do
      let(:params) { { foo: "bar" } }
      specify { expect(stop_searcher.valid?).to eq(false) }
    end
    context "with valid parameters" do
      let(:params) { { query: "foo" } }
      specify { expect(stop_searcher.valid?).to eq(true) }
    end
  end

  describe "#results" do
    context "by query" do
      let!(:matching_stop) { create(:stop, name: "8th & Walnut", code: "1234") }
      let!(:non_matching_stop) { create(:stop, name: "7th & Main", code: "456") }

      context "with a single word" do
        let(:params) { { query: "walnut" } }
        it "returns only the mating stop" do
          expect(stop_searcher.results).to eq([matching_stop])
        end
      end

      context "with multiple words" do
        let(:params) { { query: "walnut 8th" } }
        it "returns only the mating stop" do
          expect(stop_searcher.results).to eq([matching_stop])
        end
      end

      context "with a 'and' instead of '&'" do
        let(:params) { { query: "8th and walnut" } }
        it "returns only the mating stop" do
          expect(stop_searcher.results).to eq([matching_stop])
        end
      end

      context "with a spelled out street" do
        let(:params) { { query: "eighth" } }
        it "returns only the mating stop" do
          expect(stop_searcher.results).to eq([matching_stop])
        end
      end

      context "with a stop code" do
        let(:params) { { query: "1234" } }
        it "returns only the mating stop" do
          expect(stop_searcher.results).to eq([matching_stop])
        end
      end
    end

    context "with a latitude and longitude" do
      let!(:far_stop) { create(:stop, latitude: 38.104836, longitude: -85.511653) }
      let!(:near_stop) { create(:stop, latitude: 39.104836, longitude: -84.511653) }
      let(:params) { { latitude: "39.1043200", longitude: "-84.5118910" } }

      it "returns stops matching the given name" do
        expect(stop_searcher.results).to eq([near_stop, far_stop])
      end
    end
  end

  describe "pagination" do
    let!(:stops) { create_list(:stop, 9, name: "walnut") }
    let!(:last_stop) { create(:stop, name: "walnut last") }
    let(:params) { { per_page: 5, page: 2 } }

    it "paginates the results" do
      expect(stop_searcher.results.size).to eq(5)
      expect(stop_searcher.results).to include(last_stop)
    end
    it "sets per_page" do
      expect(stop_searcher.per_page).to eq(5)
    end
    it "has total_pages" do
      expect(stop_searcher.total_pages).to eq(2)
    end
    it "has a page" do
      expect(stop_searcher.page).to eq(2)
    end
    it "has total_results" do
      expect(stop_searcher.total_results).to eq(10)
    end

    context 'when per_page is a string' do
      let(:params) { { per_page: '5' } }

      it "sets per_page" do
        expect(stop_searcher.per_page).to eq(5)
      end

      it "has total_pages" do
        expect(stop_searcher.total_pages).to eq(2)
      end
    end

    context "when page is a string" do
      let(:params) { { per_page: 5, page: '2' } }

      it "has a page" do
        expect(stop_searcher.page).to eq(2)
      end

      it "paginates the results" do
        expect(stop_searcher.results.size).to eq(5)
        expect(stop_searcher.results).to include(last_stop)
      end
    end
  end
end
