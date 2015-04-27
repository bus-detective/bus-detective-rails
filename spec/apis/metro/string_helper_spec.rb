require 'spec_helper'

RSpec.describe Metro::StringHelper do
  describe "titleize" do
    let(:output) { Metro::StringHelper.titleize(input) }

    context "with nil" do
      let(:input) { nil }
      specify { expect(output).to eq(nil) }
    end

    context "with a normal caps string" do
      let(:input) { "Montgomery rd & Lester rd" }
      specify { expect(output).to eq("Montgomery rd & Lester rd") }
    end

    context "with an all caps string" do
      let(:input) { "MONTGOMERY RD & LESTER RD" }
      specify { expect(output).to eq("Montgomery rd & Lester rd") }
    end

    context "with a string containing a numbered street name" do
      let(:input) { "3RD ST - GEST ST" }
      specify { expect(output).to eq("3rd st - Gest st") }
    end
  end

  describe "titleize_headsign" do
    let(:output) { Metro::StringHelper.titleize_headsign(input) }

    context "with a normal string" do
      let(:input) { "Montgomery Express - Downtown" }
      specify { expect(output).to eq("Montgomery Express - Downtown") }
    end

    context "with a string that begins with a route number" do
      let(:input) { "33 WESTERN HILLS GLENWAY - DOWNTOWN" }
      specify { expect(output).to eq("Western Hills Glenway - Downtown") }
    end

    context "with a string that begins with an express route number" do
      let(:input) { "4X MONTGOMERY EXPRESS - DOWNTOWN" }
      specify { expect(output).to eq("Montgomery Express - Downtown") }
    end
  end
end
