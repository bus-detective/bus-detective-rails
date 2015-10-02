class Metro::ColorHelper
  def self.text_color_for_bg_color(background_color)
    red = background_color[0..1].hex
    green = background_color[2..3].hex
    blue = background_color[4..5].hex

    # This gives a luminosity value from 0 - 255
    ((0.299 * red + 0.587 * green + 0.114 * blue) > 170) ? "000000" : "FFFFFF"
  end
end
