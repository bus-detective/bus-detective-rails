class Interval
  include Comparable

  attr_reader :seconds

  def self.parse(str)
    return new(0) unless str
    h, m, s = str.split(':')

    hours = h.to_i * 3600
    mins = m.to_i * 60
    secs = s.to_i
    new(hours + mins + secs)
  end

  def self.for_time(time)
    new(time - time.at_beginning_of_day)
  end

  def initialize(args = 0)
    @seconds = args.to_i
  end

  def minutes
    @seconds / 60
  end

  def hours
    minutes / 60
  end

  # Compare this duration to another
  def <=>(other)
    return false unless other.is_a?(Interval)
    @seconds <=> other.seconds
  end

  def +(other)
    Interval.new(@seconds + other.to_i)
  end

  def -(other)
    Interval.new(@seconds - other.to_i)
  end

  def *(other)
    Interval.new(@seconds * other.to_i)
  end

  def /(other)
    Interval.new(@seconds / other.to_i)
  end

  # @return true if total is 0
  def blank?
    @seconds == 0
  end

  # @return true if total different than 0
  def present?
    !blank?
  end

  def negative?
    @negative
  end

  alias_method :to_i, :seconds
  alias_method :round, :seconds

  def to_f
    @seconds.to_f
  end

  def to_s
    h = @seconds / 3600
    m = (@seconds - h * 3600) / 60
    s = @seconds - (h * 3600) - (m * 60)
    sprintf("%02d:%02d:%02d", h, m, s)
  end
end

