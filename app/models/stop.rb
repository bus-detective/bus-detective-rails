class Stop < ActiveRecord::Base
  acts_as_mappable(lat_column_name: :latitude, lng_column_name: :longitude)
  has_many :stop_times
  has_many :trips, through: :stop_times

  # To get a stops routes, we have to query through a lot of tables:
  #
  # stops -> stop_times -> trips -> routes and it's pretty slow.
  #
  # On import we denormalize the data into route_stops for better performance.
  has_many :route_stops, dependent: :destroy
  has_many :routes, through: :route_stops

  belongs_to :agency

  def self.search(ts_query_terms)
    joins(%(INNER JOIN
            (SELECT "stops"."id" AS pg_search_id,
            ts_rank(to_tsvector('english', coalesce("stops"."name"::text, '')) || to_tsvector('english', coalesce("stops"."code"::text, '')), to_tsquery('english', '#{ts_query_terms}')), 0 AS rank
            FROM "stops" WHERE to_tsvector('english', coalesce("stops"."name"::text, '')) || to_tsvector('english', coalesce("stops"."code"::text, '')) @@ to_tsquery('english', '#{ts_query_terms}')) pg_search ON "stops"."id" = pg_search.pg_search_id))
              .order('pg_search.rank DESC, "stops"."id" ASC')
  end

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
    t = Stop.arel_table
    Stop.where(t[:id].eq(id).or(t[:remote_id].eq(id))).includes(:agency).first
  end
end
