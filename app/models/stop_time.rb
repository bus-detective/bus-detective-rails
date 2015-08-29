# This class is only used for CRUD on stop times
# If you want a REAL stop time, see CalculatedStopTime
class StopTime < ActiveRecord::Base
  belongs_to :stop
  belongs_to :trip
  belongs_to :agency
  has_one :route, through: :trip
  has_one :service, through: :trip
end

