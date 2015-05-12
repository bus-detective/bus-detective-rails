require 'rails_helper'

describe Agency do

  context 'with a realtime_endpoint' do
    subject { create(:agency, :with_rt_endpoint) }
    it { is_expected.to be_realtime }
  end

  context 'without a realtime_endpoint' do
    subject { create(:agency, realtime_endpoint: nil) }
    it { is_expected.not_to be_realtime }
  end
end
