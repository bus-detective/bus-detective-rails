class StopTime < ActiveRecord::Base
  belongs_to :stop
  belongs_to :trip
  belongs_to :agency
  has_one :route, through: :trip
  has_one :service, through: :trip

  def departure_time_on(date)
    self.class.offset_start(date) + Interval.parse(departure_time)
  end

  # FIXME: Technically all of the dates below probably need to be in the
  # timezone of the stop. To do that we probably need to have this entire query
  # run in the database so that we can convert a UTC time to local time and
  # calculate the offset there.

  # RULE: The arrival_time and departure_time are expressed as an interval.
  # The time is measured from "noon minus 12h" (effectively midnight, except
  # for days on which daylight savings time changes occur) at the beginning
  # of the service date. For times occurring after midnight on the service
  # date, enter the time as a value greater than 24:00:00 in HH:MM:SS local
  # time for the day on which the trip schedule begins. If you don't have
  # separate times for arrival and departure at a stop, enter the same value
  def self.between(start_time, end_time)
    # Start time is always treated as "today", but end time could be the following day
    # today_end is an interval from the offset described above
    today_end = Interval.new(end_time - offset_start(start_time))
    base_query = joins(trip: :service)
      .where('? between services.start_date and services.end_date', start_time)

    if start_time.day == end_time.day
      base_query
        .where("services.#{start_time.strftime('%A').downcase} AND departure_time >= interval ? AND departure_time <= interval ?",
          Interval.for_time(start_time).to_s,
          today_end.to_s)
    else
      base_query
        .where("(services.#{start_time.strftime('%A').downcase} AND departure_time >= interval ?) OR (services.#{end_time.strftime('%A').downcase} AND departure_time <= interval ?)",
          Interval.for_time(start_time).to_s,
          Interval.for_time(end_time).to_s)
    end
  end

  # You might think that noon - 12 hours is midnight.
  # You would be right most of the time, except on days that don't have 24
  # hours such as around daylight savings time changes
  def self.offset_start(time)
    time.noon - 12.hours
  end
end

