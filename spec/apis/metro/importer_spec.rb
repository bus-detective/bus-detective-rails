require 'rails_helper'

RSpec.describe Metro::Importer do
  let(:fixture) { Rails.root.join("spec/fixtures/google_transit_info.zip") }
  let(:importer) { Metro::Importer.new(endpoint: fixture) }

  describe "#agency" do
    it "is persisted" do
      expect(importer.agency).to be_persisted
    end

    it "sets the name" do
      expect(importer.agency.name).to eq("Southwest Ohio Regional Transit Authority")
    end

    it "is atomic" do
      importer.agency
      importer.agency
      expect(Agency.count).to eq(1)
    end
  end

  describe "#import_services!" do
    it "imports all the services" do
      importer.import_services!
      expect(Service.count).to eq(3)
    end

    it "is atomic" do
      importer.import_services!
      importer.import_services!
      expect(Service.count).to eq(3)
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
