class Duration
  include Comparable

  attr_reader :seconds

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
    return false unless other.is_a?(Duration)
    @seconds <=> other.seconds
  end

  def +(other)
    Duration.new(@seconds + other.to_i)
  end

  def -(other)
    Duration.new(@seconds - other.to_i)
  end

  def *(other)
    Duration.new(@seconds * other.to_i)
  end

  def /(other)
    Duration.new(@seconds / other.to_i)
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
end

