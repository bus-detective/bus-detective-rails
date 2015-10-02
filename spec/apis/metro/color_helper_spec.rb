require 'rails_helper'

RSpec.describe Metro::ColorHelper do
  describe ".text_color_for_bg_color" do
    it "uses white on top of black" do
      expect(Metro::ColorHelper.text_color_for_bg_color(Metro::ColorHelper::BLACK)).to eq(Metro::ColorHelper::WHITE)
    end

    it "uses white on top of green" do
      expect(Metro::ColorHelper.text_color_for_bg_color("008000")).to eq(Metro::ColorHelper::WHITE)
    end

    it "uses black on top of white" do
      expect(Metro::ColorHelper.text_color_for_bg_color(Metro::ColorHelper::WHITE)).to eq(Metro::ColorHelper::BLACK)
    end

    it "uses black on top of yellow" do
      expect(Metro::ColorHelper.text_color_for_bg_color("ffdd00")).to eq(Metro::ColorHelper::BLACK)
    end

    it "uses black for a nil color" do
      expect(Metro::ColorHelper.text_color_for_bg_color(nil)).to eq(Metro::ColorHelper::BLACK)
    end
  end
end
