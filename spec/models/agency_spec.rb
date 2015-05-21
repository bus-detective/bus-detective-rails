require 'rails_helper'

describe Agency do

  context 'with a gtfs_trip_updates_url' do
    subject { create(:agency, :with_rt_endpoint) }
    it { is_expected.to be_realtime }
  end

  context 'without a realtime_endpoint' do
    subject { create(:agency, gtfs_trip_updates_url: nil) }
    it { is_expected.not_to be_realtime }
  end
end
