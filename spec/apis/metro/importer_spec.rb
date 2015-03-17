require 'rails_helper'

RSpec.describe Metro::Importer do
  let(:fixture) { Rails.root.join("spec/fixtures/google_transit_info.zip") }
  let(:importer) { Metro::Importer.new(fixture) }

  describe "#import_stops!" do
    it "imports all the stops" do
      importer.import_stops!
      expect(Stop.count).to eq(12)
    end
  end

  describe "#import_routes!" do
    it "imports all the routes" do
      importer.import_routes!
      expect(Route.count).to eq(46)
    end
  end

  describe "#import_trips!" do
    it "imports all the trips" do
      importer.import_trips!
      expect(Trip.count).to eq(22)
    end
  end

  describe "#import_stop_times!" do
    it "imports all the trips" do
      importer.import_stop_times!
      expect(StopTime.count).to eq(149)
    end
  end
end
