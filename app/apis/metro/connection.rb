require 'uri'

module Metro
  class Connection
    @open_timeout = 2

    def self.open_timeout=(val)
      @open_timeout = val
    end

    def self.get(url)
      uri = if url.is_a? URI
              url
            else
              URI(url)
            end

      HTTP.timeout(:global, :write => 1, :connect => 1, :read => 3)
        .get(uri).to_s
    rescue HTTP::Error, IOError, Errno::EINVAL, Errno::ECONNRESET
      raise Metro::Error.new("Failed to get data from: #{uri}")
    end
  end
end
