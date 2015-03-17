require 'faraday'

module Metro
  class Connection
    ENDPOINT = 'http://developer.go-metro.com'

    def arrivals
      response = connection.get("/TMGTFSRealTimeWebService/TripUpdate/")
      Arrivals.new(response.body)
    end

    private

    def connection
      connection ||= Faraday.new(url: ENDPOINT)
    end
  end
end
