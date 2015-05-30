class Shape < ActiveRecord::Base
  belongs_to :agency
  has_many :shapes
end
