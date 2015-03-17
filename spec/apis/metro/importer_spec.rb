require 'rails_helper'

RSpec.describe Metro::Importer do
  let(:fixture) { Rails.root.join("spec/fixtures/google_transit_info.zip") }
  let(:importer) { Metro::Importer.new(fixture) }

  describe "#import_stops!" do
    it "imports all the stops" do
      importer.import_stops!
      expect(Stop.count).to eq(4466)
    end
  end

  describe "#import_routes!" do
    it "imports all the routes" do
      importer.import_routes!
      expect(Route.count).to eq(46)
    end
  end
end
