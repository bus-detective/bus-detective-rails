class Metro::TimeParser
  def initialize(time_string, time_zone_string)
    @time_string = time_string
    @time_zone_string = time_zone_string
  end

  def time
    return nil if @time_string.nil?
    timezone.parse(after_midnight? ? "#{hours - 24}#{minutes_and_seconds}" : @time_string)
  end

  private

  def timezone
    ActiveSupport::TimeZone[@time_zone_string]
  end

  def after_midnight?
    hours >= 24
  end

  def hours
    @time_string[0,2].to_i
  end

  def minutes_and_seconds
    @time_string[2..-1]
  end
end

