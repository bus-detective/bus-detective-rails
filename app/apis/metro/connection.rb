module Metro
  class Connection
    def self.host
      'http://developer.go-metro.com'
    end

    def self.get(endpoint)
      HTTP.get(host + endpoint).to_s
    end
  end
end
