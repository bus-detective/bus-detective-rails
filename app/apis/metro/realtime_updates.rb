require 'time'

module Metro
  class RealtimeUpdates
    def self.fetch(agency)
     url = agency.gtfs_trip_updates_url
     new(RealtimeProtobuf.fetch(url))
    end

    def initialize(feed)
      @feed = feed
    end

    def for_stop_time(stop_time)
      trip_update = for_trip(stop_time.trip)
      if trip_update
        return trip_update.stop_time_update_for(stop_time)
      end
      block_update = for_block(stop_time.trip)
      if block_update
        return block_update.stop_time_update_for(stop_time)
      end
      nil
    end

    def for_trip(trip)
      metro_id = trip.remote_id.to_s
      metro_trip = @feed[:entity].find { |entity| entity[:id] == metro_id }
      if metro_trip
        TripUpdate.new(metro_trip[:trip_update])
      else
        nil
      end
    end

    def for_block(trip)
      trip_ids = Trip.where(block_id: trip.block_id).pluck(:remote_id)
      metro_trip = @feed[:entity].find { |entity| trip_ids.include?(entity[:id]) }
      if metro_trip
        BlockUpdate.new(trip, metro_trip[:trip_update])
      else
        nil
      end
    end

    class TripUpdate
      attr_reader :trip_id
      def initialize(trip_update)
        @trip_update = trip_update
        @trip_id = @trip_update[:trip][:trip_id]
      end

      def stop_time_update_for(stop_time)
        exact_match(stop_time) || nearest_match(stop_time)
      end

      protected

      def stop_time_updates
        @stop_time_updates ||= @trip_update[:stop_time_update].map { |stu| StopTimeUpdate.new(stu) }
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

    class BlockUpdate < TripUpdate
      def initialize(trip, trip_update)
        @trip_id = trip.id
        @trip_update = trip_update
      end

      protected

      def nearest_match(stop_time)
        stop_time_updates
          .sort_by { |st| st.stop_sequence }
          .last
      end
    end



    class StopTimeUpdate
      def initialize(stop_time_update)
        @stop_time_update = stop_time_update
      end

      def stop_id
        @stop_time_update[:stop_id]
      end

      def stop_sequence
        @stop_time_update[:stop_sequence]
      end

      # For whatever reason, arrivals can come after departures ¯\_(ツ)_/¯
      def delay
        [departure[:delay], arrival[:delay]].compact.max
      end

      def departure_time
        time = [arrival[:time], departure[:time]].compact.max
        Time.at(time)
      end

      private

      # arrival or departure might be nil, so default to an empty hash
      def arrival
        @stop_time_update[:arrival] || {}
      end

      def departure
        @stop_time_update[:departure] || {}
      end
    end
  end
end
