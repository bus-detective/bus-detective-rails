class Trip < ActiveRecord::Base
  has_many :stop_times
  belongs_to :route
  belongs_to :agency
  belongs_to :service
  belongs_to :shape
end
