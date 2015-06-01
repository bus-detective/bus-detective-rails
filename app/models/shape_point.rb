class ShapePoint < ActiveRecord::Base
  belongs_to :shape
  has_one :agency, through: :shape
end
