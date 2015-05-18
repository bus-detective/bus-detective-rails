require 'spec_helper'
require 'ordinalize'

class OrdTester
  include Ordinalize
end

RSpec.describe Ordinalize do
  subject { OrdTester.new }

  it 'converts simple numbers' do
    expect(subject.englishize(1)).to eq('first')
  end

  it 'converts teen numbers' do
    expect(subject.englishize(12)).to eq('twelfth')
  end

  it 'converts big numbers' do
    expect(subject.englishize(99)).to eq('ninety-ninth')
  end
end
