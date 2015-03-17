require 'rails_helper'

RSpec.describe Metro::Importer do
  let(:fixture) { Rails.root.join("spec/fixtures/google_transit_info.zip") }
  let(:importer) { Metro::Importer.new(fixture) }

  describe "#import!" do
    it "imports all the stops" do
      importer.import!
      expect(Stop.count).to eq(4466)
    end
  end
end
