require 'rails_helper'

RSpec.describe Metro::ColorHelper do
  describe ".text_color_for_bg_color" do
    it "uses white on top of black" do
      expect(Metro::ColorHelper.text_color_for_bg_color("000000")).to eq("FFFFFF")
    end

    it "uses white on top of green" do
      expect(Metro::ColorHelper.text_color_for_bg_color("008000")).to eq("FFFFFF")
    end

    it "uses black on top of white" do
      expect(Metro::ColorHelper.text_color_for_bg_color("FFFFFF")).to eq("000000")
    end

    it "uses black on top of yellow" do
      expect(Metro::ColorHelper.text_color_for_bg_color("ffdd00")).to eq("000000")
    end
  end
end
