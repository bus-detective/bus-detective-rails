class StopSerializer < ApplicationSerializer
  attributes :id, :name, :direction, :latitude, :longitude

  def stop_id
    object.remote_id
  end

  has_many :routes
end

