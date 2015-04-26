require 'rails_helper'

RSpec.describe Service do
  describe ".for_time" do
    let(:time) { Time.zone.parse("2015-04-23") }
    let!(:applicable_service) { create(:service, thursday: true) }
    let!(:non_applicable_service) { create(:service, saturday: true) }

    it "returns services on at specified time" do
      expect(Service.for_time(time)).to eq([applicable_service])
    end
  end
end
