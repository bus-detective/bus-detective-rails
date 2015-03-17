class Metro::Importer
  DEFAULT_ENDPOINT = "http://www.go-metro.com/uploads/GTFS/google_transit_info.zip"


  def initialize(endpoint = DEFAULT_ENDPOINT)
    @endpoint = endpoint
  end

  def import!
    import_stops!
    import_routes!
    import_trips!
  end

  def import_stops!
    source.stops.each do |s|
      Stop.create!({
        stop_id: s.id,
        code: s.code,
        name: s.name,
        description: s.desc,
        lat: s.lat,
        lon: s.lon,
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

  def source
    @source ||= GTFS::Source.build(@endpoint)
  end
end
