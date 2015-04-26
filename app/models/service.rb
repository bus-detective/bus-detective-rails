class Service < ActiveRecord::Base
  belongs_to :agency
  has_many :trips
  has_many :stop_times, through: :trips

  def self.for_time(time)
    where(time.strftime('%A').downcase)
  end
end
