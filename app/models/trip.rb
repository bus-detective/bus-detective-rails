class Trip < ActiveRecord::Base
  self.primary_key = 'trip_id'
  has_many :stop_times
  belongs_to :route
end
