class StopTime < ActiveRecord::Base
  belongs_to :stop
  belongs_to :trip
  belongs_to :agency
  has_one :route, through: :trip
  has_one :service, through: :trip

  # For departures we want to go ahead and calculate the time of the departure
  # on the correct day. This is only going to work with the between below, or
  # other queries that use the 'days' query
  #
  # HINT: If you're using this, you should be using CalculatedStopTime
  # 
  # Timezones are hard.
  # They need to go in/out as UTC so Rails will properly convert them to local
  # time. But internally, we want to do comparisons in them at the timezone
  # of the agency, so we have to conver them to the local time in the between
  # query below.
  #
  def self.select_for_departure
    readonly.select("stop_times.id, stop_times.stop_sequence, stop_times.stop_headsign,
           stop_times.pickup_type, stop_times.drop_off_type,
           stop_times.shape_dist_traveled, stop_times.agency_id,
           stop_times.stop_id, stop_times.trip_id,
           ((start_time(days.d) + stop_times.arrival_time) AT TIME ZONE 'UTC') as arrival_time,
           ((start_time(days.d) + stop_times.departure_time) AT TIME ZONE 'UTC') as departure_time")
  end

  # Expand the service days into actual dates so that we can use them to calculate
  # the offset for when the bus arrives.
  def self.between(start_time, end_time)
    joins_times(start_time, end_time)
      .where("(start_time(days.d) + stop_times.departure_time) BETWEEN (? AT TIME ZONE agencies.timezone) AND (? AT TIME ZONE agencies.timezone)", start_time, end_time)
      .order("start_time(days.d) + stop_times.departure_time")
  end

  def self.joins_times(start_time, end_time)
    joins("INNER JOIN agencies ON stop_times.agency_id=agencies.id")
      .joins("INNER JOIN trips ON trips.id = stop_times.trip_id")
      .joins("INNER JOIN service_days sd ON sd.id = trips.service_id")
      .joins("INNER JOIN (select d::date from generate_series('#{start_time.to_date}', '#{end_time.to_date}', interval '1 day') d) days ON rtrim(to_char(days.d, 'day'))=sd.dow")
  end
end

