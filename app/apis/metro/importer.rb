class Metro::Importer
  def initialize(agency, options = {})
    @agency = agency
    @logger = options.fetch(:logger, Rails.logger)
  end

  def import!
    @logger.info("Fetching: #{@agency.gtfs_endpoint}")
    ActiveRecord::Base.transaction do
      # Order of these matters because dependencies in the data
      update_agency!
      @logger.info("Deleting old data before importing")
      delete_old_data!
      @logger.info("Step 1/7: Importing services (#{source.calendars.size})")
      import_services!
      @logger.info("Step 2/7: Importing services exceptions (#{source.calendar_dates.size})")
      import_services_exceptions!
      @logger.info("Step 3/7: Importing routes (#{source.routes.size})")
      import_routes!
      @logger.info("Step 4/7: Importing stops (#{source.stops.size})")
      import_stops!
      @logger.info("Step 5/7: Importing shapes (#{source.shapes.size})")
      import_shapes!
      @logger.info("Step 6/7: Importing trips (#{source.trips.size})")
      import_trips!
      @logger.info("Step 7/7: Importing stop times (#{source.stop_times.size})")
      import_stop_times!
      update_route_stop_cache!
    end
    true
  end

  def delete_old_data!
    # ServiceException and StopTime are child tables that no other tables reference
    # so blowing them away completely is fine. They also don't have remote_ids that
    # would make them easy to match with the source data.
    ServiceException.where(agency: @agency).delete_all
    StopTime.where(agency: @agency).delete_all
    ShapePoint.joins(:shape).where('shapes.agency_id = ?', @agency).delete_all
    RouteStop.joins(:route).where('routes.agency_id = ?', @agency).delete_all

    # These all have remote_id which makes the easy to identify ones that were
    # removed from the source data. They are also referenced by each other, so
    # we don't want to deal with changing primary keys (plus Stops are currently
    # stored serialized in local storage on the client, so changing IDs would mess
    # those up. Which might be a different problem.)
    Trip.where(agency: @agency).where("trips.remote_id NOT IN (?)", source.trips.map(&:id)).delete_all
    Shape.where(agency: @agency).where("shapes.remote_id NOT IN (?)", source.shapes.map(&:id)).delete_all
    Stop.where(agency: @agency).where("stops.remote_id NOT IN (?)", source.stops.map(&:id)).delete_all
    Route.where(agency: @agency).where("routes.remote_id NOT IN (?)", source.routes.map(&:id)).delete_all
    Service.where(agency: @agency).where("services.remote_id NOT IN (?)", source.calendars.map(&:service_id)).delete_all
    GC.start
  end

  def import_services!
    source.calendars.each do |cal|
      Service.find_or_initialize_by(remote_id: cal.service_id, agency: @agency).update!(
        monday: cal.monday,
        tuesday: cal.tuesday,
        wednesday: cal.wednesday,
        thursday: cal.thursday,
        friday: cal.friday,
        saturday: cal.saturday,
        sunday: cal.sunday,
        start_date: cal.start_date,
        end_date: cal.end_date
      )
    end
    GC.start
  end

  def import_services_exceptions!
    source.calendar_dates.each do |cal|
      ServiceException.create!(
        agency: @agency,
        service: Service.find_by!(remote_id: cal.service_id, agency: @agency),
        date: cal.date,
        exception: cal.exception_type
      )
    end
    GC.start
  end

  def import_stops!
    source.stops.each do |s|
      Stop.find_or_initialize_by(remote_id: s.id, agency: @agency).update!(
        code: s.code,
        name: Metro::StringHelper.titleize(s.name),
        description: Metro::StringHelper.titleize(s.desc),
        latitude: s.lat,
        longitude: s.lon,
        zone_id: s.zone_id,
        url: s.url,
        location_type: s.location_type,
        parent_station: s.parent_station,
        timezone: s.timezone || @agency.timezone,
        wheelchair_boarding: s.wheelchair_boarding
      )
    end
    GC.start
  end

  def import_routes!
    source.routes.each do |r|
      Route.find_or_initialize_by(remote_id: r.id, agency: @agency).update!(
        short_name: r.short_name,
        long_name: Metro::StringHelper.titleize(r.long_name),
        description: r.desc,
        route_type: r.type,
        url: r.url,
        color: r.color,
        text_color: Metro::ColorHelper.text_color_for_bg_color(r.color),
      )
    end
    GC.start
  end

  def import_shapes!
    # shapes.txt is a denormlized data set. We normalize the data
    # into two tables: shapes, and shape_points
    connection = ActiveRecord::Base.connection.raw_connection

    begin
      connection.prepare('insert_point', "INSERT INTO shape_points (shape_id, sequence, latitude, longitude, distance_traveled, created_at, updated_at) values($1, $2, $3, $4, $5, now() at time zone 'utc', now() at time zone 'utc')")
      source.shapes.each do |s|
        shape = Shape.find_or_create_by!(remote_id: s.id, agency: @agency)
        dist_traveled = s.dist_traveled.present? ? s.dist_traveled : 0
        connection.exec_prepared('insert_point', [shape.id, s.pt_sequence, s.pt_lat, s.pt_lon, dist_traveled])
      end
    ensure
      connection.exec('DEALLOCATE insert_point')
      GC.start
    end
  end

  def import_trips!
    source.trips.each do |t|
      Trip.find_or_initialize_by(remote_id: t.id, agency: @agency).update!(
        route: Route.find_by!(remote_id: t.route_id, agency: @agency),
        service: Service.find_by!(remote_id: t.service_id, agency: @agency),
        shape: Shape.find_by!(remote_id: t.shape_id, agency: @agency),
        headsign: Metro::StringHelper.titleize_headsign(t.headsign),
        short_name: t.short_name,
        direction_id: t.direction_id,
        block_id: t.block_id,
        wheelchair_accessible: t.wheelchair_accessible,
        bikes_allowed: t.instance_variable_get("@bikes_allowed")
      )
    end
    GC.start
  end

  def import_stop_times!
    connection = ActiveRecord::Base.connection.raw_connection

    begin
      connection.prepare('insert_stop_time', "INSERT INTO stop_times (stop_id, trip_id, agency_id, arrival_time, departure_time, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, created_at, updated_at) values($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, now() at time zone 'utc', now() at time zone 'utc')")
      source.stop_times.each do |st|
        stop = Stop.find_by!(remote_id: st.stop_id.strip, agency: @agency)
        trip = Trip.find_by!(remote_id: st.trip_id.strip, agency: @agency)
        dist_traveled = st.shape_dist_traveled.present? ? st.shape_dist_traveled : 0
        connection.exec_prepared('insert_stop_time', [stop.id, trip.id, @agency.id, st.arrival_time, st.departure_time, st.stop_sequence, st.stop_headsign, st.pickup_type, st.drop_off_type, dist_traveled])
      end
    ensure
      connection.exec('DEALLOCATE insert_stop_time')
      GC.start
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
    @source_agency ||= begin
      # assumes only one agency per import
      if source.agencies.size > 1
        raise Metro::Error.new("Only one agency is allowed per import")
      end
      source.agencies.first
    end
  end

  private

  def update_route_stop_cache!
    RouteStop.update_cache
  end

  def source
    @source ||= GTFS::Source.build(@agency.gtfs_endpoint)
  end
end
