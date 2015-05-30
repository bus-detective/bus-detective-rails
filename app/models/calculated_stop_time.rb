# To properly calculate actual StopTimes requires heavy lifting to be done in
# the database. This class allows us to wrap those results and make it look
# like a regular StopTime object
class CalculatedStopTime

  attr_reader :id, :stop_sequence, :stop_headsign, :arrival_time, :departure_time
  def initialize(options)
    @id = options[:id].to_i
    @stop_sequence       = options[:stop_sequence].to_i
    @stop_headsign       = options[:stop_headsign]
    @pickup_type         = options[:pickup_type].to_i
    @drop_off_type       = options[:drop_off_type].to_i
    @shape_dist_traveled = options[:shape_dist_traveled].to_f
    @agency_id           = options[:agency_id].to_i
    @stop_id             = options[:stop_id].to_i
    @trip_id             = options[:trip_id].to_i
    @arrival_time        = Time.zone.parse(options[:arrival_time])   if options[:arrival_time]
    @departure_time      = Time.zone.parse(options[:departure_time]) if options[:departure_time]
  end

  def agency
    @agency ||= Agency.find_by(id: @agency_id)
  end

  def stop
    @stop ||= Stop.find_by(id: @stop_id)
  end

  def trip
    @trip ||= Trip.find_by(id: @trip_id)
  end

  def route
    @route ||= trip.try(:route)
  end

  def ==(other)
    return false unless other && (other.is_a?(StopTime) || other.is_a?(CalculatedStopTime))

    other.id == self.id
  end
end



