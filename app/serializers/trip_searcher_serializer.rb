class TripSearcherSerializer < ApplicationSerializer
  attributes :total_results, :total_pages, :per_page, :page
  has_many :results
end

