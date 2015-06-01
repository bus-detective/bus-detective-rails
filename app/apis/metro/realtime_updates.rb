require 'gtfs-realtime.pb.rb'
require 'time'

module Metro
  class RealtimeUpdates
    CACHE_OPTS = {
      expires_in: 15,
      race_condition_ttl: 15
    }

    def self.fetch(agency)
     url = agency.gtfs_trip_updates_url
     new(CacheableConnection.get(url, "rt_trips:#{url}", CACHE_OPTS))
    end

    def initialize(buffer)
      @feed = TransitRealtime::FeedMessage.parse(buffer)
    rescue ProtocolBuffers::DecodeError
      raise Metro::Error.new "Problem parsing feed"
    end

    def for_stop_time(stop_time)
      trip_update = for_trip(stop_time.trip)
      if trip_update
        trip_update.stop_time_update_for(stop_time)
      else
        nil
      end
    end

    def for_trip(trip)
      metro_id = trip.remote_id.to_s
      metro_trip = @feed.entity.find { |entity| entity.id == metro_id }
      if metro_trip
        TripUpdate.new(metro_trip.trip_update)
      else
        nil
      end
    end

    class TripUpdate
      def initialize(trip_update)
        @trip_update = trip_update
      end

      def trip_id
        @trip_update.trip.trip_id
      end

      def stop_time_update_for(stop_time)
        exact_match(stop_time) || nearest_match(stop_time)
      end

      private

      def stop_time_updates
        @stop_time_updates ||= @trip_update.stop_time_update.map { |stu| StopTimeUpdate.new(stu) }
      end

      def exact_match(stop_time)
        stop_time_updates.find { |stu| stu.stop_id == stop_time.stop.remote_id }
      end

      def nearest_match(stop_time)
        stop_time_updates
          .select { |st| st.stop_sequence < stop_time.stop_sequence }
          .sort_by { |st| st.stop_sequence }
          .last
      end
    end

    class StopTimeUpdate
      delegate :stop_id, :stop_sequence, to: :@stop_time_update

      def initialize(stop_time_update)
        @stop_time_update = stop_time_update
      end

      def delay
        # Departure and Arrival always exist, an unset delay is returned as 0
        # so choose the max one to determine the delay
        [@stop_time_update.departure.delay, @stop_time_update.arrival.delay].max
      end

      def departure_time
        # For whatever reason, arrivals can come after departures ¯\_(ツ)_/¯
        time = [@stop_time_update.departure.time, @stop_time_update.arrival.time].max
        Time.at(time)
      end
    end
  end
end
