class Stop < ActiveRecord::Base
  acts_as_mappable(lat_column_name: :latitude, lng_column_name: :longitude)
  has_many :stop_times
  has_many :trips, through: :stop_times
  has_many :routes, -> { uniq }, through: :trips
  belongs_to :agency

  DIRECTION_LABELS = {
    "i" => "inbound",
    "o" => "outbound",
    "n" => "northbound",
    "s" => "southbound",
    "e" => "eastbound",
    "w" => "westbound",
  }

  def direction
    DIRECTION_LABELS[remote_id.split(//).last()]
  end
end
