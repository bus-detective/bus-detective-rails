require 'ordinalize'

module TsqueryBuilder
  extend ActiveSupport::Inflector
  extend Ordinalize

  # This is basically not tennable. We could, in theory, have streets into the hundreds
  # where people would do fiftieth or 50th
  SUBSTITUTIONS = [
    ['alley', 'aly'],
    ['avenue', 'ave'],
    ['boulevard', 'blvd'],
    ['court', 'ct'],
    ['circle', 'cir'],
    ['expressway', 'expy', 'exp'],
    ['freeway', 'fwy'],
    ['highway', 'hwy'],
    ['lane', 'ln'],
    ['place', 'pl'],
    ['parkway', 'pkwy'],
    ['road', 'rd'],
    ['route', 'rte'],
    ['square', 'sq', 'sqr'],
    ['street', 'st', 'str'],
  ]
  (1...99).each do |i|
    SUBSTITUTIONS << [i.to_s, englishize(i), ordinalize(i)]
  end

  # Preprocess the above so we can just look up by a key
  SUBSTITUTION_MAP = SUBSTITUTIONS.each_with_object({}) { |ts, map| ts.each {|term| map[term] = ts }}

  def self.build(query)
    return unless query

    query_parts = query.strip.downcase.split(/&|and/)
    query_parts.map { |q| build_ts_query(q) }.map { |q| "(#{q})" }.join(" & ")
  end

  private

  def self.build_ts_query(query)
    query.split(' ').map { |q| expand(q) }.join(" & ")
  end

  def self.expand(term)
    ts = SUBSTITUTION_MAP[term]
    return term unless ts

    "(#{ts.join(' | ')})"
  end
end

