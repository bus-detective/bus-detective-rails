require 'spec_helper'

RSpec.describe Metro::TimeParser do
  subject(:gtfs_time) { Metro::TimeParser.new(time_string, timezone_string) }

  describe "#time" do
    context "with a time before midnight" do
      let(:time_string) { "07:00:00" }
      let(:timezone_string) { "America/Detroit" }

      it "parses the time" do
        expect(gtfs_time.time).to eq(ActiveSupport::TimeZone["America/Detroit"].parse("07:00:00"))
      end
    end

    context "with a time after midnight" do
      let(:time_string) { "25:00:00" }
      let(:timezone_string) { "America/Detroit" }

      it "parses the time minus 24 hours" do
        expect(gtfs_time.time).to eq(ActiveSupport::TimeZone["America/Detroit"].parse("01:00:00"))
      end
    end

    context "in a different timezone" do
      let(:time_string) { "7:00:00" }
      let(:timezone_string) { "America/Chicago" }

      it "parses the time in that timezone" do
        expect(gtfs_time.time).to eq(ActiveSupport::TimeZone["America/Chicago"].parse("07:00:00"))
      end
    end

    context "with a nil time_string" do
      let(:time_string) { nil }
      let(:timezone_string) { "America/Chicago" }

      it "is nil" do
        expect(gtfs_time.time).to eq(nil)
      end
    end
  end
end
