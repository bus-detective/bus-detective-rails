class Route < ActiveRecord::Base
  self.primary_key = 'route_id'
  has_many :trips
end
