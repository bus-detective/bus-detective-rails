require 'uri'

module Metro
  class Connection

    def self.get(url)
      uri = if url.is_a? URI
              url
            else
              URI(url)
            end

      Net::HTTP.get(uri)
    end
  end
end
