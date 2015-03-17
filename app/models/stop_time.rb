class StopTime < ActiveRecord::Base
  belongs_to :stop
  belongs_to :trip
end
