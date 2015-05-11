module Metro
  class Connection
    def self.host
      'http://developer.go-metro.com'
    end

    def self.get(endpoint)
      Net::HTTP.get(host, endpoint)
    end
  end
end
