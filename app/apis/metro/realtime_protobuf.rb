require 'gtfs-realtime.pb.rb'

module Metro
  class RealtimeProtobuf
    include Skylight::Helpers

    CACHE_OPTS = {
      expires_in: 15,
      race_condition_ttl: 15
    }

    def self.fetch(url)
      Rails.cache.fetch(url, CACHE_OPTS) do
        Rails.logger.warn("Cache expired, fetching: #{url}")
        buffer = Connection.get(url)
        parse(buffer)
      end
    end

    instrument_method title: 'parsing protobuf'
    def self.parse(buffer)
      TransitRealtime::FeedMessage.parse(buffer).to_hash
    rescue ProtocolBuffers::DecodeError
      raise Metro::Error.new "Problem parsing feed"
    end
  end
end
