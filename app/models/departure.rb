class Departure
  include ActiveModel::SerializerSupport
  attr_reader :stop_time

  def initialize(options)
    @date = options.fetch(:date)
    @stop_time = options.fetch(:stop_time)
    @stop_time_update = options.fetch(:stop_time_update)
  end

  delegate :route, :trip, to: :stop_time

  def duration_from(t)
    ::Interval.new(time - t)
  end

  def realtime?
    @stop_time_update.present?
  end

  def time
    if @stop_time_update
      @stop_time_update.departure_time
    else
      @stop_time.departure_time_on(@date)
    end
  end

  def delay
    if @stop_time_update
      @stop_time_update.delay
    else
      0
    end
  end
end
