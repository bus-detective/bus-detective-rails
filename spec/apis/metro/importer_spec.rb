require 'rails_helper'

RSpec.describe Metro::Importer do
  let(:fixture) { Rails.root.join("spec/fixtures/google_transit_info.zip") }
  let(:importer) { Metro::Importer.new(endpoint: fixture) }

  describe "#import_agency!" do
    it "imports the first agency in the source" do
      importer.import_agency!
      expect(Agency.count).to eq(1)
    end

    it "is atomic" do
      importer.import_agency!
      importer.import_agency!
      expect(Agency.count).to eq(1)
    end
  end

  describe "#import_stops!" do
    it "imports all the stops" do
      importer.import_stops!
      expect(Stop.count).to eq(12)
    end

    it "is atomic" do
      importer.import_stops!
      importer.import_stops!
      expect(Stop.count).to eq(12)
    end
  end

  describe "#import_routes!" do
    it "imports all the routes" do
      importer.import_routes!
      expect(Route.count).to eq(46)
    end

    it "is atomic" do
      importer.import_routes!
      importer.import_routes!
      expect(Route.count).to eq(46)
    end
  end

  describe "#import_trips!" do
    it "imports all the trips" do
      importer.import_trips!
      expect(Trip.count).to eq(22)
    end

    it "is atomic" do
      importer.import_trips!
      importer.import_trips!
      expect(Trip.count).to eq(22)
    end
  end

  describe "#import_stop_times!" do
    it "imports all the trips" do
      importer.import_stop_times!
      expect(StopTime.count).to eq(149)
    end

    it "is atomic" do
      importer.import_stop_times!
      importer.import_stop_times!
      expect(StopTime.count).to eq(149)
    end
  end

  describe "#import" do
    it "imports everything" do
      expect(importer.import!).to eq(true)
    end
  end
end
