require 'rails_helper'

RSpec.describe Metro::Importer do
  let(:fixture_path) { Rails.root.join("spec/fixtures/google_transit_info.zip") }
  let(:fake_agency) { create(:agency, gtfs_endpoint: fixture_path) }
  let(:importer) { Metro::Importer.new(fake_agency) }

  describe "update_agency!" do
    it "sets the agencies name" do
      importer.update_agency!
      expect(fake_agency.name).to eq("Southwest Ohio Regional Transit Authority")
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
      expect(Stop.count).to eq(10)
    end

    it "is atomic" do
      importer.import_stops!
      importer.import_stops!
      expect(Stop.count).to eq(10)
    end
  end

  describe "#import_routes!" do
    it "imports all the routes" do
      importer.import_routes!
      expect(Route.count).to eq(10)
    end

    it "is atomic" do
      importer.import_routes!
      importer.import_routes!
      expect(Route.count).to eq(10)
    end
  end

  describe "#import_trips!" do
    it "imports all the trips" do
      importer.import_trips!
      expect(Trip.count).to eq(10)
    end

    it "is atomic" do
      importer.import_trips!
      importer.import_trips!
      expect(Trip.count).to eq(10)
    end
  end

  describe "#import_stop_times!" do
    it "imports all the trips" do
      importer.import_stop_times!
      expect(StopTime.count).to eq(10)
    end

    it "is atomic" do
      importer.import_stop_times!
      importer.import_stop_times!
      expect(StopTime.count).to eq(10)
    end
  end

  describe "#import" do
    it "imports everything" do
      expect(importer.import!).to eq(true)
    end
  end
end
