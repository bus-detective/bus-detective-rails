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
  def self.select_for_departure
    readonly.select("stop_times.id, stop_times.stop_sequence, stop_times.stop_headsign,
           stop_times.pickup_type, stop_times.drop_off_type,
           stop_times.shape_dist_traveled, stop_times.agency_id,
           stop_times.stop_id, stop_times.trip_id, ((days.d + stop_times.arrival_time)
           at time zone agencies.timezone) as arrival_time, ((days.d + stop_times.departure_time)
           at time zone agencies.timezone) as departure_time")
  end

  def self.between(start_time, end_time)
    joins("INNER JOIN agencies ON stop_times.agency_id=agencies.id")
      .joins("INNER JOIN trips ON trips.id = stop_times.trip_id")
      .joins("INNER JOIN service_days sd ON sd.id = trips.service_id")
      .joins("INNER JOIN (select d::date from generate_series('#{start_time.to_date}', '#{end_time.to_date}', interval '1 day') d) days ON  rtrim(to_char(days.d, 'day'))=sd.dow")
      .where("((days.d + stop_times.departure_time) at time zone agencies.timezone) BETWEEN (TIMESTAMP ? at time zone 'UTC') AND (TIMESTAMP ? at time zone 'UTC')", start_time, end_time)
      .order("days.d + stop_times.departure_time")
  end
end

