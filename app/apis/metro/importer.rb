class Metro::Importer
  DEFAULT_ENDPOINT = "http://www.go-metro.com/uploads/GTFS/google_transit_info.zip"

  def initialize(options)
    @endpoint = options.fetch(:endpoint, DEFAULT_ENDPOINT)
    @logger = options.fetch(:logger, Rails.logger)
    @logger.info("fetching #{@endpoint}")
  end

  def import!
    ActiveRecord::Base.transaction do
      @logger.info("step 1/5: importing agency #{agency.name}")
      import_agency!
      @logger.info("step 2/5: importing routes (#{source.routes.size})")
      import_routes!
      @logger.info("step 3/5: importing stops (#{source.stops.size})")
      import_stops!
      @logger.info("step 4/5: importing trips (#{source.trips.size})")
      import_trips!
      @logger.info("step 5/5: importing stop times (#{source.stop_times.size})")
      import_stop_times!
      true
    end
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
    source.stops.each do |s|
      Stop.create!({
        stop_id: s.id,
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
      })
    end
  end

  def import_routes!
    source.routes.each do |r|
      Route.create!({
        route_id: r.id,
        agency_id: r.agency_id,
        short_name: r.short_name,
        long_name: r.long_name,
        description: r.desc,
        route_type: r.type,
        url: r.url,
        color: r.color,
        text_color: r.text_color
      })
    end
  end

  def import_trips!
    source.trips.each do |t|
      Trip.create!({
        trip_id: t.id,
        route_id: t.route_id,
        service_id: t.service_id,
        headsign: t.headsign,
        short_name: t.short_name,
        direction_id: t.direction_id,
        block_id: t.block_id,
        shape_id: t.shape_id,
        wheelchair_accessible: t.wheelchair_accessible,
        bikes_allowed: t.instance_variable_get("@bikes_allowed")
      })
    end
  end

  def import_stop_times!
    source.stop_times.each do |s|
      StopTime.create!({
        trip_id: s.trip_id,
        arrival_time: s.arrival_time,
        departure_time: s.departure_time,
        stop_id: s.stop_id,
        stop_sequence: s.stop_sequence,
        stop_headsign: s.stop_headsign,
        pickup_type: s.pickup_type,
        drop_off_type: s.drop_off_type,
        shape_dist_traveled: s.shape_dist_traveled
      })
    end
  end

  def agency
    # assumes only one agency per import
    if source.agencies.count > 1
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
