class StopTime < ActiveRecord::Base
  belongs_to :stop
  belongs_to :trip
  belongs_to :agency
  has_one :route, through: :trip
  has_one :service, through: :trip


  def departure_time_on(date)
    start_time = date.at_beginning_of_day + 12.hours - 12.hours
    start_time + Interval.parse(departure_time)
  end

  # RULE: The arrival_time and departure_time are expressed as an interval.
  # The time is measured from "noon minus 12h" (effectively midnight, except
  # for days on which daylight savings time changes occur) at the beginning
  # of the service date. For times occurring after midnight on the service
  # date, enter the time as a value greater than 24:00:00 in HH:MM:SS local
  # time for the day on which the trip schedule begins. If you don't have
  # separate times for arrival and departure at a stop, enter the same value
  def self.between(start_time, end_time)
    base_clause =
      joins(trip: :service)
      .where("services.#{start_time.strftime('%A').downcase} AND departure_time >= interval ?", Interval.for_time(start_time).to_s)
      .includes(:trip)

    if start_time.day != end_time.day
      # assume we cross over a day
      # Get the end time as an interval from the start of the previous day to check for today's routes
      # Use the end_date as is to check for "tomorrows" routes
      today_end = Interval.new(end_time - start_time.at_beginning_of_day)
      base_clause.where("(services.#{start_time.strftime('%A').downcase} AND departure_time <= interval ?) OR (services.#{end_time.strftime('%A').downcase} AND departure_time <= interval ?)", 
                        today_end.to_s,
                        Interval.for_time(end_time).to_s)

    else
      # assume we are within a single day
      base_clause.where("departure_time <= interval ?", Interval.for_time(end_time).to_s)
    end
  end
end

