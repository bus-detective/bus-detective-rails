require 'gtfs-realtime.pb.rb'
require 'time'

module Metro
  class RealtimeArrivals
    def initialize(buffer)
      @feed = TransitRealtime::FeedMessage.parse(buffer)
    end

    def for_stop(stop_id)
      all.select { |a| a[:stop_id].downcase == stop_id.downcase }
    end

    def all
      @all ||= trip_updates.map { |tu| tu.arrivals }.flatten
    end

    private

    def trip_updates
      @trip_updates ||= @feed.entity.map { |e| TripUpdate.new(e.trip_update) }
    end

    class TripUpdate
      def initialize(options)
        @trip = options.trip
        @stop_time_updates = options.stop_time_update
      end

      def arrivals
        @arrivals ||= @stop_time_updates.map { |stu|
          {
            stop_id: stu.stop_id,
            trip_id: @trip.trip_id.to_i,
            route_id: @trip.route_id.to_i,
            stop_sequence: stu.stop_sequence,
            time: available_time(stu),
            delay: stu.departure.delay,
          }
        }
      end

      def available_time(stu)
        time = [stu.departure.time, stu.arrival.time].max
        Time.at(time).iso8601
      end
    end
  end
end
