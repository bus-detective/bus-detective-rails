require 'spec_helper'
require 'metro/routes.rb'

module Metro
  RSpec.describe Routes do
    describe '.all' do
      it 'returns all known routes' do
        expect(Routes.all.length).to eq(46)
      end
    end
  end
end

