require 'rails_helper'

RSpec.describe "stops api" do
  let(:json) { JSON.parse(response.body) }

  describe "api/stops?name=" do
    it "returns stops with the given street name" do
      get '/api/stops?name=8th'
      expect(json["stops"].first["stop_id"]).to eq("8THWALi")
    end
  end
end

