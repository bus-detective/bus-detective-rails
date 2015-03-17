require 'csv'

module Metro
  class Routes
    def self.all
      csv = CSV.read "spec/fixtures/routes.txt", headers: true
      csv.map { |line| line.to_hash }
    end
  end
end
