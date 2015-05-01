class Metro::Importer
  def initialize(agency, options = {})
    @agency = agency
    @logger = options.fetch(:logger, Rails.logger)
    @logger.info("Fetching #{@endpoint}")
  end

  def import!
    @logger.info("Importing agency #{source_agency.name}")
    update_agency!
    @logger.info("Step 1/5: Importing services (#{source.calendars.size})")
    import_services!
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

  def import_services!
    source.each_calendar do |cal|
      Service.find_or_create_by!(remote_id: cal.service_id, agency: @agency) do |record|
        record.attributes = {
          monday: cal.monday,
          tuesday: cal.tuesday,
          wednesday: cal.wednesday,
          thursday: cal.thursday,
          friday: cal.friday,
          saturday: cal.saturday,
          sunday: cal.sunday,
          start_date: cal.start_date,
          end_date: cal.end_date
        }
      end
    end
  end

  def import_stops!
    source.each_stop do |s|
      Stop.find_or_create_by!(remote_id: s.id, agency: @agency) do |record|
        record.attributes = {
          code: s.code,
          name: Metro::StringHelper.titleize(s.name),
          description: Metro::StringHelper.titleize(s.desc),
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
      Route.find_or_create_by!(remote_id: r.id, agency: @agency) do |record|
        record.attributes = {
          short_name: r.short_name,
          long_name: Metro::StringHelper.titleize(r.long_name),
          description: r.desc,
          route_type: r.type,
          url: r.url,
          color: r.color,
          text_color: "fff"
        }
      end
    end
  end

  def import_trips!
    source.each_trip do |t|
      trip = Trip.find_or_create_by(remote_id: t.id, agency: @agency)
      trip.update!(
        route: Route.find_or_create_by!(remote_id: t.route_id, agency: @agency),
        service: Service.find_or_create_by!(remote_id: t.service_id, agency: @agency),
        remote_id: t.id,
        agency: @agency,
        headsign: Metro::StringHelper.titleize_headsign(t.headsign),
        short_name: t.short_name,
        direction_id: t.direction_id,
        block_id: t.block_id,
        shape_id: t.shape_id,
        wheelchair_accessible: t.wheelchair_accessible,
        bikes_allowed: t.instance_variable_get("@bikes_allowed")
      )
    end
  end

  def import_stop_times!
    source.each_stop_time do |st|
      stop = Stop.find_or_create_by!(remote_id: st.stop_id, agency: @agency)
      trip = Trip.find_or_create_by!(remote_id: st.trip_id, agency: @agency)
      stop_time = StopTime.find_or_create_by(stop: stop, trip: trip, agency: @agency)
      stop_time.update!(
        arrival_time: Metro::TimeParser.new(st.arrival_time, source_agency.timezone).time,
        departure_time: Metro::TimeParser.new(st.departure_time, source_agency.timezone).time,
        stop_sequence: st.stop_sequence,
        stop_headsign: st.stop_headsign,
        pickup_type: st.pickup_type,
        drop_off_type: st.drop_off_type,
        shape_dist_traveled: st.shape_dist_traveled
      )
    end
  end

  def update_agency!
    @agency.update!(
      remote_id: source_agency.id,
      name: source_agency.name,
      url: source_agency.url,
      fare_url: source_agency.fare_url,
      timezone: source_agency.timezone,
      language: source_agency.lang,
      phone: source_agency.phone
    )
  end

  def source_agency
    # assumes only one agency per import
    if source.agencies.size > 1
      raise InvalidDataError.new("Only one agency is allowed per import")
    end

    source.agencies.first
  end

  private

  def source
    @source ||= GTFS::Source.build(@agency.gtfs_endpoint)
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
