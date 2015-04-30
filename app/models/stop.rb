class Stop < ActiveRecord::Base
  acts_as_mappable(lat_column_name: :latitude, lng_column_name: :longitude)
  has_many :stop_times
  has_many :trips, through: :stop_times
  has_many :routes, -> { uniq }, through: :trips
  belongs_to :agency

  include PgSearch
  pg_search_scope :search, against: [:name, :code]

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

  def self.find_legacy(id)
    # This is to support the case where a user has a favorite saved from
    # before the switch to postres generated ids
    Stop.where(id: id).first || Stop.find_by!(remote_id: id)
  end
end
