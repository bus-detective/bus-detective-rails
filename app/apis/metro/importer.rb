class Metro::Importer
  DEFAULT_ENDPOINT = "http://www.go-metro.com/uploads/GTFS/google_transit_info.zip"


  def initialize(endpoint = DEFAULT_ENDPOINT)
    @endpoint = endpoint
  end

  def import!
    import_stops!
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

  def source
    @source ||= GTFS::Source.build(@endpoint)
  end
end
