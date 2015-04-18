class Metro::Importer
  DEFAULT_ENDPOINT = "http://www.go-metro.com/uploads/GTFS/google_transit_info.zip"

  def initialize(options)
    @endpoint = options.fetch(:endpoint, DEFAULT_ENDPOINT)
    @logger = options.fetch(:logger, Rails.logger)
    @logger.info("Fetching #{@endpoint}")
  end

  def import!
    @logger.info("Step 1/5: Importing agency #{agency.name}")
    import_agency!
    @logger.info("Step 2/5: Importing routes (#{source.routes.size})")
    import_routes!
    @logger.info("Step 3/5: Importing stops (#{source.stops.size})")
    import_stops!
    @logger.info("Step 4/5: Importing trips (#{source.trips.size})")
    import_trips!
    @logger.info("Step 5/5: Importing stop times (#{source.stop_times.size})")
    import_stop_times!
    true
  end

  def import_agency!
    # assumes only one agency per import
    a = source.agencies.first
    agency.update!({
      name: a.name,
      url: a.url,
      fare_url: a.fare_url,
      timezone: a.timezone,
      language: a.lang,
      phone: a.phone
    })
  end

  def import_stops!
    source.each_stop do |s|
      Stop.find_or_create_by!(remote_id: s.id, agency: agency) do |record|
        record.attributes = {
          code: s.code,
          name: s.name,
          description: s.desc,
          latitude: s.lat,
          longitude: s.lon,
          zone_id: s.zone_id,
          url: s.url,
          location_type: s.location_type,
          parent_station: s.parent_station,
          timezone: s.timezone,
          wheelchair_boarding: s.wheelchair_boarding
        }
      end
    end
  end

  def import_routes!
    source.each_route do |r|
      Route.find_or_create_by!(remote_id: r.id, agency: agency) do |record|
        record.attributes = {
          short_name: r.short_name,
          long_name: r.long_name,
          description: r.desc,
          route_type: r.type,
          url: r.url,
          color: r.color,
          text_color: r.text_color
        }
      end
    end
  end

  def import_trips!
    source.each_trip do |t|
      route = Route.find_or_create_by!(remote_id: t.route_id, agency: agency)
      Trip.find_or_create_by!(remote_id: t.id, agency: agency) do |record|
        record.attributes = {
          route: route,
          service_id: t.service_id,
          headsign: t.headsign,
          short_name: t.short_name,
          direction_id: t.direction_id,
          block_id: t.block_id,
          shape_id: t.shape_id,
          wheelchair_accessible: t.wheelchair_accessible,
          bikes_allowed: t.instance_variable_get("@bikes_allowed")
        }
      end
    end
  end

  def import_stop_times!
    source.each_stop_time do |st|
      stop = Stop.find_or_create_by!(remote_id: st.stop_id, agency: agency)
      trip = Trip.find_or_create_by!(remote_id: st.trip_id, agency: agency)
      StopTime.find_or_create_by!(stop: stop, trip: trip, agency: agency) do |record|
        record.attributes = {
          arrival_time: st.arrival_time,
          departure_time: st.departure_time,
          stop_sequence: st.stop_sequence,
          stop_headsign: st.stop_headsign,
          pickup_type: st.pickup_type,
          drop_off_type: st.drop_off_type,
          shape_dist_traveled: st.shape_dist_traveled
        }
      end
    end
  end

  def agency
    # assumes only one agency per import
    if source.agencies.size > 1
      raise InvalidDataError.new("Only one agency is allowed per import")
    end
    @agency ||= Agency.find_or_create_by(remote_id: source.agencies.first.id)
  end

  private

  def source
    @source ||= GTFS::Source.build(@endpoint)
  end

  class Error < StandardError
    attr_reader :original_exception

    def initialize(exception = nil)
      @original_exception = exception
      super
    end
  end

  InvalidDataError = Class.new(Error)
end
