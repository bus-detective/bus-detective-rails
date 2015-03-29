class Stop < ActiveRecord::Base
  acts_as_mappable(lat_column_name: :latitude, lng_column_name: :longitude)
  self.primary_key = 'stop_id'
  has_many :stop_times

  DIRECTION_LABELS = {
    "i" => "inbound",
    "o" => "outbound",
    "n" => "northbound",
    "s" => "southbound",
    "e" => "eastbound",
    "w" => "westbound",
  }

  def direction
    DIRECTION_LABELS[id.split(//).last()]
  end
end
