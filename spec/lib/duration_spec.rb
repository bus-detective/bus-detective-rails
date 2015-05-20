require 'spec_helper'

RSpec.describe Interval do
  let!(:now) { Time.now }

  context 'one hour' do
    subject { Interval.new(3600) }

    it 'prints itself' do
      expect(subject.to_s).to eq('01:00:00')
    end

    it 'can parse' do
      expect(Interval.parse("01:00:00")).to eq(subject)
    end

    it 'can add a duration to it' do
      expect(subject + subject).to eq(Interval.new(3600 * 2))
    end

    it 'can add it to a date' do
      # TODO: Can we do this without to_i?
      expect(now + Interval.new(60).to_i).to eq(now + 1.minute)
    end

    it 'generate one from a time' do
      expect(Interval.for_time(Time.now.beginning_of_day + 1.hour)).to eq(subject)
    end
  end

  context 'one and a half hour' do
    subject { Interval.new(5400) }

    it 'prints itself' do
      expect(subject.to_s).to eq('01:30:00')
    end
  end

  context 'one hour, one minute, 59 seconds' do
    subject { Interval.new(3719) }

    it 'prints itself' do
      expect(subject.to_s).to eq('01:01:59')
    end
  end
end

