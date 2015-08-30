require 'rails_helper'

RSpec.describe CalculatedStopTime do
  let(:agency) { create(:agency) }
  let(:trip) { create(:trip, agency: agency, remote_id: 940135, service: create(:service, agency: agency, tuesday: true, wednesday: true)) }
  let(:stop) { create(:stop, agency: agency, remote_id: "HAMBELi") }
  let(:ten_minutes) { Interval.new(10.minutes) }

  let(:stop_times) { CalculatedStopTime.between(start_time, end_time).to_a }

  context "stops on different days" do
    before do
      create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: '22:00:00')
      create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: '23:00:00')
      create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: '00:30:00')
      create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: '01:00:00')
    end

    context 'requesting stops on the same day' do
      let(:start_time) { Time.parse("2015-05-12 22:00:00 -0400") }
      let(:end_time) { Time.parse("2015-05-12 23:30:00 -0400") }

      it 'can find those stops' do
        expect(stop_times.size).to eq(2)
      end
    end

    context 'having stops that cross the local time day boundary' do
      let(:start_time) { Time.parse("2015-05-12 23:00:00 -0400") }
      let(:end_time) { Time.parse("2015-05-13 01:30:00 -0400") }

      it 'can find those stops' do
        expect(stop_times.size).to eq(3)
      end
    end
  end

  context 'stops on the same day' do
    before do
      create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: '22:00:00')
      create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: '23:00:00')
      create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: '24:30:00')
      create(:stop_time, agency: agency, stop: stop, trip: trip, departure_time: '25:00:00')
    end

    context 'having stops on the same day' do
      let(:start_time) { Time.parse("2015-05-12 22:00:00 -0400") }
      let(:end_time) { Time.parse("2015-05-12 23:30:00 -0400") }

      it 'can find those stops' do
        expect(stop_times.size).to eq(2)
      end
    end

    context 'having stops that cross the local time day boundary' do
      let(:start_time) { Time.parse("2015-05-12 23:00:00 -0400") }
      let(:end_time) { Time.parse("2015-05-13 01:30:00 -0400") }

      it 'can find those stops' do
        expect(stop_times.size).to eq(3)
      end
    end
  end
end
