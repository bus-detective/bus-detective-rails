class Stop < ActiveRecord::Base
  acts_as_mappable(lat_column_name: :latitude, lng_column_name: :longitude)
  has_many :stop_times
  belongs_to :agency

  DIRECTION_LABELS = {
    "i" => "inbound",
    "o" => "outbound",
    "n" => "northbound",
    "s" => "southbound",
    "e" => "eastbound",
    "w" => "westbound",
  }

  def routes
    Route.joins(trips: :stop_times).where(stop_times: { stop_id: self.id }).uniq.order(:id)
  end

  def direction
    DIRECTION_LABELS[remote_id.split(//).last()]
  end
end
