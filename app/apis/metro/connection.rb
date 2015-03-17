module Metro
  class Connection
    def self.arrivals
      response_body = get("/TMGTFSRealTimeWebService/TripUpdate/")
      Arrivals.new(response_body)
    end

    private

    def self.host
      'http://developer.go-metro.com'
    end

    def self.get(endpoint)
      HTTP.get(host + endpoint).to_s
    end
  end
end
