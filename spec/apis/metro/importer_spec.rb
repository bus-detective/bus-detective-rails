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
    it "is atomic" do
      importer.import!
      importer.import_services!
      expect(Service.count).to eq(3)
    end
  end

  describe "#import_stops!" do
    it "is atomic" do
      importer.import!
      importer.import_stops!
      expect(Stop.count).to eq(10)
    end
  end

  describe "#import_routes!" do
    it "is atomic" do
      importer.import!
      importer.import_routes!
      expect(Route.count).to eq(10)
    end
  end

  describe "#import_shapes!" do
    it "is atomic" do
      importer.import!
      importer.import!
      # We delete all the ShapPoints in import, so we're just ensuring they're all deleted and recreated
      expect(Shape.count).to eq(1)
      expect(ShapePoint.count).to eq(10)
    end
  end

  describe "#import_trips!" do
    it "is atomic" do
      importer.import!
      importer.import_trips!
      expect(Trip.count).to eq(10)
    end
  end

  describe "#import" do
    it "imports everything" do
      expect(importer.import!).to eq(true)
      expect(Trip.count).to eq(10)
      expect(Route.count).to eq(10)
      expect(Stop.count).to eq(10)
      expect(Service.count).to eq(3)
      expect(StopTime.count).to eq(10)
      expect(ServiceException.count).to eq(2)
      expect(Shape.count).to eq(1)
      expect(ShapePoint.count).to eq(10)
    end
  end
end
