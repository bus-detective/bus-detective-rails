class Stop < ActiveRecord::Base
  acts_as_mappable(lat_column_name: :latitude, lng_column_name: :longitude)
  self.primary_key = 'stop_id'
  has_many :stop_times
end
