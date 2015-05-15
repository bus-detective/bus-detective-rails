require 'rails_helper'

RSpec.describe StopTime do
  let(:agency) { create(:agency) }
  let(:trip) { create(:trip, agency: agency, remote_id: 940135, service: create(:service, agency: agency, tuesday: true)) }
  let(:stop) { create(:stop, agency: agency, remote_id: "HAMBELi") }
  before do
    create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.for_time(start_time - 10.minutes).to_s)
    create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.for_time(start_time + 10.minutes).to_s)
    create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.for_time(end_time - 10.minutes).to_s)
    create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: Interval.for_time(end_time + 10.minutes).to_s)
  end

  let(:stop_times) { StopTime.between(start_time, end_time).to_a }

  context 'having stops on the same day' do
    let(:start_time) { Time.zone.parse("2015-05-12 20:30:00 Z") }
    let(:end_time) { Time.zone.parse("2015-05-12 21:30:00 Z") }

    it 'can find those stops' do
      expect(stop_times.size).to eq(2)
    end
  end

  context 'having stops that cross the UTC day boundary' do
    let(:start_time) { Time.zone.parse("2015-05-12 23:30:00 Z") }
    let(:end_time) { Time.zone.parse("2015-05-13 01:30:00 Z") }

    it 'can find those stops' do
      expect(stop_times.size).to eq(2)
    end
  end
end
