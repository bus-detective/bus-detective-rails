require 'spec_helper'
require 'metro/stops.rb'

module Metro
  RSpec.describe Stops do
    describe '.all' do
      it 'returns all the stops' do
        expect(Stops.all.length).to eq(4465)
      end
    end

    describe '.search' do
      it 'returns stops by a search query' do
        expect(Stops.search("Blue Ash").length).to eq(40)
      end
    end
  end
end
