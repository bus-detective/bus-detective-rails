class TripDetailSerializer < TripSerializer
  has_one :shape
  has_one :route
end

