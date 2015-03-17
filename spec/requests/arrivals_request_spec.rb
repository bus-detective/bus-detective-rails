require 'rails_helper'

RSpec.describe "arrivals api" do
  let(:json) { JSON.parse(response.body) }

  before do
    allow(Metro::Connection).to receive(:get).and_return(fixture)
  end

  describe "api/arrivals" do
    let(:fixture) { File.read('spec/fixtures/arrivals.buf') }

    it "returns all arrivals" do
      get '/api/arrivals'
      expect(json["arrivals"].length).to eq(6370)
    end
  end
end
