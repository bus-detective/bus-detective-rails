class StopTime < ActiveRecord::Base
  belongs_to :stop
  belongs_to :trip
  belongs_to :agency
  has_one :route, through: :trip
  has_one :service, through: :trip

  def self.between(start_time, end_time)
    # Dates are converted to UTC in the database, so compare them as UTC here
    if start_time.utc.hour > end_time.utc.hour
      # assume we cross over a day
      where("departure_time > ? OR departure_time < ?", start_time, end_time)
    else
      # assume we are within a single day
      where("departure_time > ? AND departure_time < ?", start_time, end_time)
    end
  end
end
