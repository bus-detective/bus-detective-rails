class StopTime < ActiveRecord::Base
  belongs_to :stop
  belongs_to :trip
  belongs_to :agency
  has_one :route, through: :trip
end
