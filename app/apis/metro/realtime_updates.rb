require 'gtfs-realtime.pb.rb'
require 'time'

module Metro
  class RealtimeUpdates
    def self.fetch(agency)
      new(Connection.get(agency.realtime_endpoint))
    end

    def initialize(buffer)
      @feed = TransitRealtime::FeedMessage.parse(buffer)
    end

    def for_stop_time(stop_time)
      trip_update = for_trip(stop_time.trip)
      if trip_update
        trip_update.stop_time_updates.find { |stu| stu.stop_id == stop_time.stop.remote_id }
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

      def stop_time_updates
        @trip_update.stop_time_update.map { |stu| StopTimeUpdate.new(stu) }
      end
    end

    class StopTimeUpdate
      def initialize(stop_time_update)
        @stop_time_update = stop_time_update
      end

      def stop_id
        @stop_time_update.stop_id
      end

      def delay
        @stop_time_update.departure.delay
      end

      def departure_time
        # For whatever reason, arrivals can come after departures ¯\_(ツ)_/¯
        time = [@stop_time_update.departure.time, @stop_time_update.arrival.time].max
        Time.at(time)
      end
    end
  end
end
