class Metro::StringHelper
  EXCLUDED = []

  def self.titleize(string)
    return nil if string.nil?
    string.split(" ").map { |word| EXCLUDED.include?(word.downcase) ? word.downcase : word.capitalize }.join(" ")
  end

  def self.titleize_headsign(string)
    return nil if string.nil?
    titleize(string.gsub(/^\d+[Xx]? /, ""))
  end
end
