require 'csv'

module Metro
  class Stops
    def self.all
      csv = CSV.read "spec/fixtures/stops.txt", headers: true
      csv.map { |line| line.to_hash }
    end

    def self.search(name)
      regex = Regexp.new(/#{name}/i)
      all.select { |stop| regex.match(stop['stop_name']) }
    end
  end
end
