require 'spec_helper'

RSpec.describe Duration do
  let!(:now) { Time.now }

  context 'one hour' do
    subject { Duration.new(3600) }

    it 'prints itself' do
      expect(subject.to_s).to eq('01:00:00')
    end

    it 'can parse' do
      expect(Duration.parse("01:00:00")).to eq(subject)
    end

    it 'can add a duration to it' do
      expect(subject + subject).to eq(Duration.new(3600 * 2))
    end

    it 'can add it to a date' do
      # TODO: Can we do this without to_i?
      expect(now + Duration.new(60).to_i).to eq(now + 1.minute)
    end

    it 'generate one from a time' do
      expect(Duration.for_time(Time.now.beginning_of_day + 1.hour)).to eq(subject)
    end
  end

  context 'one and a half hour' do
    subject { Duration.new(5400) }

    it 'prints itself' do
      expect(subject.to_s).to eq('01:30:00')
    end
  end

  context 'one hour, one minute, 59 seconds' do
    subject { Duration.new(3719) }

    it 'prints itself' do
      expect(subject.to_s).to eq('01:01:59')
    end
  end
end

